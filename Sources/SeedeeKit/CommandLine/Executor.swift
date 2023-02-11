import Foundation

protocol Executor {
    /// Execute the command and arguments using `bash`.
    /// - Parameters:
    ///   - command: The command to run.
    ///   - arguments: The arguments to execute.
    ///   - workingDirectory: The path to the directory under which to run the process.
    @discardableResult
    func execute(
        _ command: String,
        arguments: [String],
        workingDirectory: URL,
        process: Process
    ) throws -> ExecutorResult
}

extension Executor {
    @discardableResult
    func execute(
        _ command: String,
        workingDirectory: URL = URL(fileURLWithPath: ".")
    ) throws -> ExecutorResult {
        try execute(
            command,
            arguments: [],
            workingDirectory: workingDirectory,
            process: .init())
    }
}

struct ExecutorResult {
    let arguments: String
    let terminationStatus: Int32
    let output: String
}

struct ProcessExecutor: Executor {
    /// Execute the command and arguments using `bash`.
    /// - Parameters:
    ///   - command: The command to run.
    ///   - arguments: The arguments to execute.
    ///   - workingDirectory: The path to the directory under which to run the process.
    @discardableResult
    func execute(
        _ command: String = "",
        arguments: [String] = [],
        workingDirectory: URL,
        process: Process = .init()
    ) throws -> ExecutorResult {
        let command = "cd \(workingDirectory.path.escapingSpaces) && \(command) \(arguments.joined(separator: " "))"

        logger.info("$ \(command)")
        return try process.run(with: command)
    }
}

// MARK: - Private

private extension Process {
    @discardableResult
    func run(
        with command: String,
        outputHandle: FileHandle? = nil,
        errorHandle: FileHandle? = nil
    ) throws -> ExecutorResult {
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
        return try outputQueue.sync {
            if terminationStatus != 0 {
                let error = Error(
                    terminationStatus: self.terminationStatus,
                    errorData: errorData,
                    outputData: outputData
                )

                logger.error(error.message)
                throw error
            }

            return ExecutorResult(
                arguments: command,
                terminationStatus: terminationStatus,
                output: outputData.shellOutput()
            )
        }
    }

    struct Error: Swift.Error {
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
