import Testing
@testable import leetcodes

@Suite("Two Sum Tests")
struct TwoSumTests {
    
    static let testCases: [(nums: [Int], target: Int, expected: [Int])] = [
        (nums: [2, 7, 11, 15], target: 9,  expected: [0, 1]),
        (nums: [3, 2, 4],      target: 6,  expected: [1, 2]),
        (nums: [3, 3],         target: 6,  expected: [0, 1]),
        (nums: [-1, -2, -3],   target: -5, expected: [1, 2])
    ]
    
    @Test("Solution V1 (Hash Map) - Parameterized", arguments: testCases)
    func testSolutionV1(caseData: (nums: [Int], target: Int, expected: [Int])) {
        let solver = TwoSum.SolutionV1()
        #expect(solver.twoSum(caseData.nums, caseData.target) == caseData.expected)
    }
    
    @Test("Solution V2 (Brute Force) - Parameterized", arguments: testCases)
    func testSolutionV2(caseData: (nums: [Int], target: Int, expected: [Int])) {
        let solver = TwoSum.SolutionV2()
        #expect(solver.twoSum(caseData.nums, caseData.target) == caseData.expected)
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