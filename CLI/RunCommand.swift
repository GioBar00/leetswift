import Foundation
import ArgumentParser
import leetcodes

struct RunCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "run",
        abstract: "Run a specific LeetCode challenge solution with the provided input."
    )
    
    @Argument(help: "The unique slug or directory path of the challenge (e.g., 'two-sum' or './Sources/leetcodes/two-sum').")
    var slugOrPath: String
    
    @Option(name: .shortAndLong, help: "The solution variant to run (e.g., 'v1', 'v2').")
    var solution: String = "v1"
    
    @Option(name: .shortAndLong, help: "Inline input data in JSON format.")
    var input: String?
    
    @Option(name: .shortAndLong, help: "Path to a file containing input data in JSON format.")
    var file: String?
    
    func validate() throws {
        if input == nil && file == nil {
            throw ValidationError("Please specify either inline input (--input / -i) or a linked file (--file / -f).")
        }
        if input != nil && file != nil {
            throw ValidationError("Please specify only one: either inline input (--input / -i) or a linked file (--file / -f), not both.")
        }
    }
    
    func run() throws {
        let normalizedSlug = CLIHelpers.resolveSlug(from: slugOrPath)
        
        guard let challenge = ChallengeRegistry.challenges[normalizedSlug] else {
            throw LeetCodeError.unknownChallenge(normalizedSlug)
        }
        
        var rawInput: String = ""
        
        if let inlineInput = input {
            rawInput = inlineInput
        } else if let filePath = file {
            let expandedPath = NSString(string: filePath).expandingTildeInPath
            let url = URL(fileURLWithPath: expandedPath)
            
            do {
                rawInput = try String(contentsOf: url, encoding: .utf8)
            } catch {
                throw LeetCodeError.invalidInput("Failed to read input file at '\(filePath)': \(error.localizedDescription)")
            }
        }
        
        let trimmedInput = rawInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("🚀 Running \(challenge.name)...")
        print("------------------------------------------------------------------")
        print("  Challenge: \(normalizedSlug)")
        print("  Solution:  \(solution)")
        print("  Input:     \(trimmedInput.count > 100 ? String(trimmedInput.prefix(100)) + "..." : trimmedInput)")
        print("------------------------------------------------------------------")
        
        let clock = ContinuousClock()
        let start = clock.now
        
        do {
            let output = try challenge.run(solutionId: solution, inputJson: trimmedInput)
            let duration = clock.now - start
            
            print("✨ Execution Successful!")
            print("------------------------------------------------------------------")
            print("  Result: \(output)")
            print("  Time:   \(CLIHelpers.formatDuration(duration))")
            print("==================================================================\n")
        } catch let error as LeetCodeError {
            throw error
        } catch {
            throw LeetCodeError.executionError(error.localizedDescription)
        }
    }
}
