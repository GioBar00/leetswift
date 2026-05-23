import Foundation
import ArgumentParser
import leetcodes

struct TestCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "test",
        abstract: "Run unit tests for a specific LeetCode challenge."
    )
    
    @Argument(help: "The unique slug or directory path of the challenge to test (e.g., 'two-sum').")
    var slugOrPath: String
    
    func run() throws {
        let slug = CLIHelpers.resolveSlug(from: slugOrPath)
        
        // Validate challenge exists
        guard let challenge = ChallengeRegistry.challenges[slug] else {
            throw LeetCodeError.unknownChallenge(slug)
        }
        
        let pascalName = CLIHelpers.toPascalCase(slug: slug)
        let filterPattern = "\(pascalName)Tests"
        
        print("🧪 Running Tests for: \(challenge.name)")
        print("------------------------------------------------------------------")
        print("  Filter: \(filterPattern)")
        print("------------------------------------------------------------------\n")
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", "test", "--filter", filterPattern]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        let fileHandle = pipe.fileHandleForReading
        
        // Stream stdout/stderr in real-time
        fileHandle.readabilityHandler = { handle in
            let data = handle.availableData
            if !data.isEmpty {
                try? FileHandle.standardOutput.write(contentsOf: data)
            }
        }
        
        do {
            try process.run()
            process.waitUntilExit()
            fileHandle.readabilityHandler = nil
        } catch {
            fileHandle.readabilityHandler = nil
            throw LeetCodeError.executionError("Failed to start swift test runner process: \(error.localizedDescription)")
        }
        
        print("\n------------------------------------------------------------------")
        if process.terminationStatus == 0 {
            print("✔ Tests Completed Successfully!")
        } else {
            print("❌ Tests Failed (Status Code: \(process.terminationStatus))")
            throw ExitCode(process.terminationStatus)
        }
        print("==================================================================\n")
    }
}
