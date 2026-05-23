#!/usr/bin/env swift
import Foundation

// MARK: - Protocols & DTOs for Future-Proof Scraping
protocol LeetCodeMetadataProvider {
    func fetchMetadata(for slug: String) -> ProblemMetadata
}

struct ProblemMetadata {
    let title: String
    let camelCaseName: String
    let difficulty: String
    let problemStatement: String
}

// MARK: - Current Manual / Rule-Based Metadata Generator
class LocalMetadataProvider: LeetCodeMetadataProvider {
    func fetchMetadata(for slug: String) -> ProblemMetadata {
        // Simple conversion: "two-sum" -> "Two Sum" and "TwoSum"
        let components = slug.components(separatedBy: "-")
        let title = components.map { $0.capitalized }.joined(separator: " ")
        let camelCaseName = components.map { $0.capitalized }.joined()
        
        return ProblemMetadata(
            title: title,
            camelCaseName: camelCaseName,
            difficulty: "Easy (Change if needed)",
            problemStatement: "Paste the problem statement here from LeetCode."
        )
    }
}

// MARK: - Template Generator
class TemplateGenerator {
    private let fileManager = FileManager.default
    private let currentDirectory: URL
    
    init() {
        self.currentDirectory = URL(fileURLWithPath: fileManager.currentDirectoryPath)
    }
    
    func createSetup(for slug: String, metadata: ProblemMetadata) throws {
        // Define directory paths
        let sourceDir = currentDirectory
            .appendingPathComponent("Sources")
            .appendingPathComponent("leetcodes")
            .appendingPathComponent(slug)
            
        let testDir = currentDirectory
            .appendingPathComponent("Tests")
            .appendingPathComponent("leetcodesTests")
            .appendingPathComponent(slug)
            
        // 1. Create directories on disk
        try fileManager.createDirectory(at: sourceDir, withIntermediateDirectories: true, attributes: nil)
        try fileManager.createDirectory(at: testDir, withIntermediateDirectories: true, attributes: nil)
        
        print("📁 Created directories:")
        print("  - \(sourceDir.path)")
        print("  - \(testDir.path)")
        
        // 2. Generate and write README.md (Option B: Markdown Table)
        let readmeContent = """
        # \(metadata.title)

        \(metadata.problemStatement)

        ## Difficulty: \(metadata.difficulty)

        ---

        ## Complexity & Explanations

        | Version | Time Complexity | Space Complexity | Approach Description |
        | :--- | :--- | :--- | :--- |
        | **V1 (Initial)** | O(?) | O(?) | Describe initial approach here. |

        ---

        ## Link
        https://leetcode.com/problems/\(slug)/
        """
        try readmeContent.write(to: sourceDir.appendingPathComponent("README.md"), atomically: true, encoding: .utf8)
        
        // 3. Generate and write Namespace.swift
        let namespaceContent = """
        import Foundation

        /// Namespace for \(metadata.title) challenge
        public enum \(metadata.camelCaseName): LeetCodeChallenge {
            public static var slug: String { "\(slug)" }
            public static var name: String { "\(metadata.title)" }
            
            public static func run(solutionId: String, inputJson: String) throws -> String {
                let decoder = JSONDecoder()
                _ = decoder // Silences unused warning during initial setup
                
                // TODO: Define your input model, decode it, and run the solution.
                // For example:
                // let input = try decoder.decode(Int.self, from: Data(inputJson.utf8))
                // let result = SolutionV1().solve(input)
                // return String(describing: result)
                
                switch solutionId.lowercased() {
                case "v1", "solutionv1":
                    return "TODO: Implement run logic in \(metadata.camelCaseName).swift"
                default:
                    throw LeetCodeError.unknownSolution(solutionId)
                }
            }
        }
        """
        try namespaceContent.write(to: sourceDir.appendingPathComponent("\(metadata.camelCaseName).swift"), atomically: true, encoding: .utf8)
        
        // 4. Generate and write [CamelCase]_v1.swift (Option A: Xcode-native Triple-Slash Popover Docstrings)
        let solutionContent = """
        import Foundation

        extension \(metadata.camelCaseName) {
            /// **Approach 1: Initial Solution**
            ///
            /// A detailed description of the first approach and how it works.
            ///
            /// - Complexity:
            ///   - **Time:** O(?)
            ///   - **Space:** O(?)
            ///
            /// - Note: Add any important notes, constraints, or boundary conditions handled here.
            public struct SolutionV1 {
                public init() {}
                
                public func solve() {
                    // Write solution here
                }
            }
        }
        """
        try solutionContent.write(to: sourceDir.appendingPathComponent("\(metadata.camelCaseName)_v1.swift"), atomically: true, encoding: .utf8)
        
        // 4b. Generate and write [CamelCase]+Benchmark.swift
        let benchmarkContent = """
        import Foundation

        extension \(metadata.camelCaseName) {
            public static func runBenchmarks() {
                // Define benchmark inputs of different sizes
                let inputs: [(size: Int, data: String)] = [
                    (size: 10, data: "input_10"),
                    (size: 100, data: "input_100"),
                    (size: 1000, data: "input_1000")
                ]
                
                BenchmarkRunner.run(
                    challenge: "\(slug)",
                    solution: "SolutionV1",
                    inputs: inputs
                ) { input in
                    // Call your solution here:
                    // _ = SolutionV1().solve(input)
                }
            }
        }
        """
        try benchmarkContent.write(to: sourceDir.appendingPathComponent("\(metadata.camelCaseName)+Benchmark.swift"), atomically: true, encoding: .utf8)
        
        // 5. Generate and write [CamelCase]Tests.swift (Granular Parameterized Testing)
        let testsContent = """
        import Testing
        @testable import leetcodes

        @Suite("\(metadata.title) Tests")
        struct \(metadata.camelCaseName)Tests {
            
            // Define the test data collection of input parameters and expected outputs
            static let testCases: [(input: String, expected: Bool)] = [
                ("example_input", true)
            ]
            
            @Test("Solution V1 - Initial Solution", arguments: testCases)
            func testSolutionV1(caseData: (input: String, expected: Bool)) {
                // let solver = \(metadata.camelCaseName).SolutionV1()
                // #expect(solver.solve(caseData.input) == caseData.expected)
            }
            
            @Test("Solution V1 with Large Input File")
            func testSolutionV1LargeInput() throws {
                guard let rawInput = TestDataLoader.loadString(fileName: "input_large.txt") else {
                    Issue.record("Failed to load large input file")
                    return
                }
                
                // Parse rawInput and run test...
                #expect(!rawInput.isEmpty)
            }
        }
        """
        try testsContent.write(to: testDir.appendingPathComponent("\(metadata.camelCaseName)Tests.swift"), atomically: true, encoding: .utf8)
        
        // 6. Generate and write empty input_large.txt
        let largeInputContent = "// Paste large input data here\n"
        try largeInputContent.write(to: testDir.appendingPathComponent("input_large.txt"), atomically: true, encoding: .utf8)
        
        print("✍️ Created template files:")
        print("  - README.md")
        print("  - \(metadata.camelCaseName).swift")
        print("  - \(metadata.camelCaseName)_v1.swift")
        print("  - \(metadata.camelCaseName)+Benchmark.swift")
        print("  - \(metadata.camelCaseName)Tests.swift")
        print("  - input_large.txt")
    }
    
    func registerChallenge(slug: String, camelCaseName: String) throws {
        let registryURL = currentDirectory
            .appendingPathComponent("Sources")
            .appendingPathComponent("leetcodes")
            .appendingPathComponent("Shared")
            .appendingPathComponent("ChallengeRegistry.swift")
        
        guard fileManager.fileExists(atPath: registryURL.path) else {
            print("⚠️ Warning: ChallengeRegistry.swift not found at \(registryURL.path). Skipped auto-registration.")
            return
        }
        
        var content = try String(contentsOf: registryURL, encoding: .utf8)
        
        // Check if already registered
        if content.contains("\"\(slug)\":") {
            print("ℹ️ Challenge '\(slug)' is already registered in ChallengeRegistry.swift.")
            return
        }
        
        // Find standard dictionary start
        let pattern = "challenges: \\[String: any LeetCodeChallenge\\.Type\\] = \\["
        if let range = content.range(of: pattern, options: .regularExpression) {
            let insertPos = range.upperBound
            let registryEntry = "\n        \"\(slug)\": \(camelCaseName).self,"
            content.insert(contentsOf: registryEntry, at: insertPos)
            
            try content.write(to: registryURL, atomically: true, encoding: .utf8)
            print("✏️ Automatically registered '\(slug)' in ChallengeRegistry.swift")
        } else {
            print("⚠️ Warning: Could not locate standard challenges dictionary in ChallengeRegistry.swift. Please register manually.")
        }
    }
}

// MARK: - Main Runner
func main() {
    let arguments = CommandLine.arguments
    guard arguments.count > 1 else {
        print("❌ Error: Missing argument.")
        print("Usage: swift create.swift <leetcode-snail-case-name>")
        print("Example: swift create.swift two-sum")
        exit(1)
    }
    
    let slug = arguments[1]
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .lowercased()
    
    // Simple validation (must be alphanumeric and hyphens only)
    let regex: NSRegularExpression
    do {
        regex = try NSRegularExpression(pattern: "^[a-z0-9-]+$")
    } catch {
        print("❌ Internal Error: Failed to compile slug validation regex: \(error.localizedDescription)")
        exit(1)
    }
    let range = NSRange(location: 0, length: slug.utf16.count)
    if regex.firstMatch(in: slug, options: [], range: range) == nil {
        print("❌ Error: Invalid slug '\(slug)'.")
        print("Slugs should be lowercased and separated by hyphens (e.g., 'longest-common-prefix').")
        exit(1)
    }
    
    let provider = LocalMetadataProvider()
    let metadata = provider.fetchMetadata(for: slug)
    
    let generator = TemplateGenerator()
    
    do {
        print("🚀 Setting up LeetCode: \(slug)...")
        try generator.createSetup(for: slug, metadata: metadata)
        try generator.registerChallenge(slug: slug, camelCaseName: metadata.camelCaseName)
        print("✅ Setup complete! Reloading your Xcode project or running the CLI will automatically display the new challenge.")
    } catch {
        print("❌ Critical Error: \(error.localizedDescription)")
        exit(1)
    }
}

main()
