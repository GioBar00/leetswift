import Foundation

public enum ChallengeRegistry {
    public static let challenges: [String: any LeetCodeChallenge.Type] = [
        "two-sum": TwoSum.self
    ]
}
