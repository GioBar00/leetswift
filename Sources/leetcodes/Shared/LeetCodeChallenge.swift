import Foundation

public enum LeetCodeError: LocalizedError {
    case unknownChallenge(String)
    case unknownSolution(String)
    case missingInput
    case invalidInput(String)
    case executionError(String)
    
    public var errorDescription: String? {
        switch self {
        case .unknownChallenge(let slug):
            return "Unknown LeetCode challenge: '\(slug)'"
        case .unknownSolution(let id):
            return "Unknown solution variant: '\(id)'"
        case .missingInput:
            return "No input provided. Please use --input or --file."
        case .invalidInput(let details):
            return "Invalid input format: \(details)"
        case .executionError(let msg):
            return "Execution error: \(msg)"
        }
    }
}

public protocol LeetCodeChallenge: Sendable {
    /// The unique URL slug of the challenge (e.g. "palindrome-number").
    static var slug: String { get }
    
    /// The friendly name of the challenge (e.g. "Palindrome Number").
    static var name: String { get }
    
    /// Runs benchmarks for all solutions associated with this challenge.
    static func runBenchmarks()
    
    /// Executes a specific solution version with a generic JSON input.
    ///
    /// - Parameters:
    ///   - solutionId: The solution variant (e.g., "v1", "v2").
    ///   - inputJson: A JSON string representing the inputs (e.g., simple type or container struct).
    /// - Returns: A string representation of the computed solution output.
    static func run(solutionId: String, inputJson: String) throws -> String
}
