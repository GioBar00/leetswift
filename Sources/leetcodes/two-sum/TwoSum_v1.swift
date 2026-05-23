import Foundation

extension TwoSum {
    /// **Approach 1: Hash Map (Single Pass)**
    ///
    /// Iterates once over `nums`. For each element, calculates its complement
    /// (`target - num`) and checks if it already exists in a hash map. If found,
    /// the pair of indices is returned immediately. Otherwise, the current number
    /// and its index are stored in the map for future lookups.
    ///
    /// - Complexity:
    ///   - **Time:** O(N) — single traversal; each hash map lookup is O(1) amortized.
    ///   - **Space:** O(N) — the hash map stores at most N entries.
    ///
    /// - Note: The problem guarantees exactly one solution exists, so the empty
    ///   return at the end is unreachable in valid inputs.
    public struct SolutionV1 {
        public init() {}
        
        public func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
            var numToIndex = [Int: Int]()
            for (index, num) in nums.enumerated() {
                let complement = target - num
                if let complementIndex = numToIndex[complement] {
                    return [complementIndex, index]
                }
                numToIndex[num] = index
            }
            return []
        }
    }
}