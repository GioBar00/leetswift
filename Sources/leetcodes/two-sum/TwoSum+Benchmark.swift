import Foundation

extension TwoSum {
    public static func runBenchmarks() {
        // Define benchmark inputs of different sizes
        let inputs: [(size: Int, data: (nums: [Int], target: Int))] = [10, 100, 1000].map { size in
            let nums = Array(1...size)
            let target = size + (size - 1)
            return (size: size, data: (nums: nums, target: target))
        }
        
        BenchmarkRunner.run(
            challenge: "two-sum",
            solution: "SolutionV1 (Hash Map)",
            inputs: inputs
        ) { data in
            _ = SolutionV1().twoSum(data.nums, data.target)
        }
        
        BenchmarkRunner.run(
            challenge: "two-sum",
            solution: "SolutionV2 (Brute Force)",
            inputs: inputs
        ) { data in
            _ = SolutionV2().twoSum(data.nums, data.target)
        }
    }
}