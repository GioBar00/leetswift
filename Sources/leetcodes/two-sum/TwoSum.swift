import Foundation

/// Namespace for Two Sum challenge
public enum TwoSum: LeetCodeChallenge {
    public static var slug: String { "two-sum" }
    public static var name: String { "Two Sum" }
    
    public struct Arguments: Decodable {
        public let nums: [Int]
        public let target: Int
        
        public init(nums: [Int], target: Int) {
            self.nums = nums
            self.target = target
        }
    }
    
    public static func run(solutionId: String, inputJson: String) throws -> String {
        let decoder = JSONDecoder()
        let args: Arguments
        
        do {
            args = try decoder.decode(Arguments.self, from: Data(inputJson.utf8))
        } catch {
            throw LeetCodeError.invalidInput("Expected a JSON object with 'nums' ([Int]) and 'target' (Int), e.g., {\"nums\": [2, 7, 11, 15], \"target\": 9}. Received: \(inputJson)")
        }
        
        switch solutionId.lowercased() {
        case "v1", "solutionv1":
            let result = SolutionV1().twoSum(args.nums, args.target)
            return String(describing: result)
        case "v2", "solutionv2":
            let result = SolutionV2().twoSum(args.nums, args.target)
            return String(describing: result)
        default:
            throw LeetCodeError.unknownSolution(solutionId)
        }
    }
}