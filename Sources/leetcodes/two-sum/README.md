# Two Sum

Given an array of integers `nums` and an integer `target`, return *indices of the two numbers such that they add up to `target`*.

You may assume that each input would have **exactly one solution**, and you may not use the same element twice.

You can return the answer in any order.

**Example 1:**
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: nums[0] + nums[1] == 9, so return [0, 1].
```

**Example 2:**
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```

**Constraints:**
- `2 <= nums.length <= 10⁴`
- `-10⁹ <= nums[i] <= 10⁹`
- `-10⁹ <= target <= 10⁹`
- Only one valid answer exists.

## Difficulty: Easy

---

## Complexity & Explanations

| Version | Time Complexity | Space Complexity | Approach Description |
| :--- | :--- | :--- | :--- |
| **V1 (Hash Map)** | O(N) | O(N) | Single pass: store each number's index in a hash map. For each element, check if its complement (`target - num`) already exists in the map. Returns immediately on first match. |
| **V2 (Brute Force)** | O(N²) | O(1) | Nested loops: for each element, scan all subsequent elements to find the complement. No extra space needed but quadratic time. |

---

## Link
https://leetcode.com/problems/two-sum/