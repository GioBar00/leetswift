import Foundation
import ArgumentParser

struct LeetSwift: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "leetswift",
        abstract: "🚀 LeetCode Swift Diary CLI Tool for local execution, parameterized testing, and high-fidelity benchmarks.",
        subcommands: [
            ListCommand.self,
            RunCommand.self,
            BenchmarkCommand.self,
            TestCommand.self
        ],
        defaultSubcommand: ListCommand.self
    )
}

LeetSwift.main()
