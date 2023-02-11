import Foundation

protocol Executor {
    /// Execute the command and arguments using `bash`.
    /// - Parameters:
    ///   - command: The command to run.
    ///   - arguments: The arguments to execute.
    ///   - workingDirectory: The path to the directory under which to run the process.
    ///   - completion:
    ///   - completion: A completion to be fulfilled with a result is `ExecutorResult`.
    func execute(
        _ command: String,
        arguments: [String],
        workingDirectory: URL,
        process: Process,
        completion: @escaping (Result<ExecutorResult, ExecutorError>) -> Void
    )
}

extension Executor {
    func execute(
        _ command: String,
        workingDirectory: URL = URL(fileURLWithPath: "."),
        completion: @escaping (Result<ExecutorResult, ExecutorError>) -> Void
    ) {
        execute(
            command,
            arguments: [],
            workingDirectory: workingDirectory,
            process: .init(),
            completion: completion)
    }
}

struct ExecutorResult {
    let arguments: String
    let terminationStatus: Int32
    let output: String
}

struct ExecutorError: Swift.Error {
    /// The termination status of the command that was run
    let terminationStatus: Int32
    /// The error message as a UTF8 string, as returned through `STDERR`
    var message: String { return errorData.shellOutput() }
    /// The raw error buffer data, as returned through `STDERR`
    let errorData: Data
    /// The raw output buffer data, as retuned through `STDOUT`
    let outputData: Data
    /// The output of the command as a UTF8 string, as returned through `STDOUT`
    var output: String { return outputData.shellOutput() }
}

struct ProcessExecutor: Executor {
    func execute(
        _ command: String,
        arguments: [String],
        workingDirectory: URL,
        process: Process,
        completion: @escaping (Result<ExecutorResult, ExecutorError>) -> Void
    ) {
        let command = "cd \(workingDirectory.path.escapingSpaces) && \(command) \(arguments.joined(separator: " "))"

        logger.info("$ \(command)")
        process.run(with: command, completion: completion)
    }
}

// MARK: - Private

private extension Process {
    func run(
        with command: String,
        outputHandle: FileHandle? = nil,
        errorHandle: FileHandle? = nil,
        completion: @escaping (Result<ExecutorResult, ExecutorError>) -> Void
    ) {
        launchPath = "/bin/bash"
        arguments = ["-c", command]

        // Because FileHandle's readabilityHandler might be called from a
        // different queue from the calling queue, avoid a data race by
        // protecting reads and writes to outputData and errorData on
        // a single dispatch queue.
        let outputQueue = DispatchQueue(label: "com.ldakhoa.Seedee.CommandLine.outputQueue")

        var outputData = Data()
        var errorData = Data()

        let outputPipe = Pipe()
        standardOutput = outputPipe

        let errorPipe = Pipe()
        standardError = errorPipe

        #if !os(Linux)
        outputPipe.fileHandleForReading.readabilityHandler = { handler in
            let data = handler.availableData
            outputQueue.async {
                outputData.append(data)
                outputHandle?.write(data)
            }
        }

        errorPipe.fileHandleForReading.readabilityHandler = { handler in
            let data = handler.availableData
            outputQueue.async {
                errorData.append(data)
                errorHandle?.write(data)
            }
        }
        #endif

        launch()

        #if os(Linux)
        outputQueue.sync {
            outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        }
        #endif

        waitUntilExit()

        if let handle = outputHandle, !handle.isStandard {
            handle.closeFile()
        }

        if let handle = errorHandle, !handle.isStandard {
            handle.closeFile()
        }

        #if !os(Linux)
        outputPipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil
        #endif

        // Block until all writes have occurred to outputData and errorData,
        // and then read the data back out.
        outputQueue.sync {
            if self.terminationStatus != 0 {
                let error = ExecutorError(
                    terminationStatus: self.terminationStatus,
                    errorData: errorData,
                    outputData: outputData
                )

                completion(.failure(error))
            } else {
                let result = ExecutorResult(
                    arguments: command,
                    terminationStatus: self.terminationStatus,
                    output: outputData.shellOutput()
                )
                completion(.success(result))
            }
        }
    }
}

private extension FileHandle {
    var isStandard: Bool {
        return self === FileHandle.standardOutput ||
            self === FileHandle.standardError ||
            self === FileHandle.standardInput
    }
}

private extension Data {
    func shellOutput() -> String {
        guard let output = String(data: self, encoding: .utf8) else {
            return ""
        }

        guard !output.hasSuffix("\n") else {
            let endIndex = output.index(before: output.endIndex)
            return String(output[..<endIndex])
        }

        return output

    }
}

private extension String {
    var escapingSpaces: String {
        return replacingOccurrences(of: " ", with: "\\ ")
    }
}
