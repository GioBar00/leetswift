import Foundation
import ArgumentParser
import leetcodes

struct BenchmarkCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "benchmark",
        abstract: "Run performance benchmarks for a specific LeetCode challenge."
    )
    
    @Argument(help: "The unique slug or directory path of the challenge to benchmark (e.g., 'two-sum' or './Sources/leetcodes/two-sum').")
    var slugOrPath: String
    
    @Option(name: [.customShort("n"), .long], help: "Override default benchmark execution iteration count.")
    var iterations: Int?
    
    @Option(name: .shortAndLong, help: "Override default benchmark warmup loop count.")
    var warmup: Int?
    
    func run() throws {
        let normalizedSlug = CLIHelpers.resolveSlug(from: slugOrPath)
        
        guard let challenge = ChallengeRegistry.challenges[normalizedSlug] else {
            throw LeetCodeError.unknownChallenge(normalizedSlug)
        }
        
        // Expose configuration overrides to the core module
        BenchmarkConfig.iterationsOverride = iterations
        BenchmarkConfig.warmupOverride = warmup
        
        print("⚡️ Initializing Benchmarks for: \(challenge.name)")
        print("------------------------------------------------------------------")
        if let it = iterations {
            print("  Iterations Override: \(it)")
        }
        if let wm = warmup {
            print("  Warmup Override:     \(wm)")
        }
        if iterations != nil || warmup != nil {
            print("------------------------------------------------------------------")
        }
        
        challenge.runBenchmarks()
        
        print("📊 Benchmarking Complete!")
    }
}
