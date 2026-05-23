import Foundation

extension TwoSum {
    /// **Approach 2: Brute Force**
    ///
    /// The simplest possible solution. It iterates through every pair of elements and checks
    /// if their sum is equal to the target.
    ///
    /// - Complexity:
    ///   - **Time:** O(N²) where N is the number of elements. We compare each element with every other element.
    ///   - **Space:** O(1) auxiliary space as we do not use any dynamic data structures.
    public struct SolutionV2 {
        public init() {}
        
        public func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
            for i in 0..<nums.count {
                for j in (i + 1)..<nums.count {
                    if nums[i] + nums[j] == target {
                        return [i, j]
                    }
                }
            }
            return []
        }
    }
}
