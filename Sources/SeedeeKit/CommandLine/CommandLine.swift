import Foundation

 /// Run a command line command using Bash.
public struct CommandLine {

    /// The command to run.
    private let command: String

    /// The arguments to execute.
    private let arguments: [String]

    /// The path to the directory under which to run the process.
    private let workingDirectory: String

    /// Which process to use to perform the command (default: A new one)
    private let process: Process

    /// Create an instance using a POSIX process exit status code and output result.
    /// - Parameters:
    ///   - command: The command to run.
    ///   - arguments: The arguments to execute.
    ///   - workingDirectory: The path to the directory under which to run the process.
    public init(
        command: String,
        arguments: [String] = [],
        workingDirectory: String = ".",
        process: Process = .init()
    ) {
        self.command = command
        self.arguments = arguments
        self.workingDirectory = workingDirectory
        self.process = process
    }

    @discardableResult
    public func launch() throws -> String {
        let command = "cd \(workingDirectory.escapingSpaces) && \(command) \(arguments.joined(separator: " "))"

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
    ) throws -> String {
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
                throw CommandLineError(
                    terminationStatus: terminationStatus,
                    errorData: errorData,
                    outputData: outputData
                )
            }

            return outputData.shellOutput()
        }
    }
}

public struct CommandLineError: Error {
    /// The termination status of the command that was run
    public let terminationStatus: Int32
    /// The error message as a UTF8 string, as returned through `STDERR`
    public var message: String { return errorData.shellOutput() }
    /// The raw error buffer data, as returned through `STDERR`
    public let errorData: Data
    /// The raw output buffer data, as retuned through `STDOUT`
    public let outputData: Data
    /// The output of the command as a UTF8 string, as returned through `STDOUT`
    public var output: String { return outputData.shellOutput() }
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
