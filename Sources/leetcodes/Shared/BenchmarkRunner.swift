import Foundation
#if canImport(Darwin)
import MachO
#endif

public struct BenchmarkResult: Codable {
    public let inputSize: Int
    public let averageTimeMicroseconds: Double
    public let memoryBytesUsed: Int // Shifted to absolute memory footprint in bytes
}

public struct BenchmarkReport: Codable {
    public let challenge: String
    public let solution: String
    public let timestamp: String
    public let results: [BenchmarkResult]
}

public struct BenchmarkConfig {
    public nonisolated(unsafe) static var iterationsOverride: Int? = nil
    public nonisolated(unsafe) static var warmupOverride: Int? = nil
}

public enum BenchmarkRunner {
    
    /// Runs performance benchmarks on a given solution block for multiple input sizes.
    /// - Parameters:
    ///   - challenge: The folder name or ID of the LeetCode (e.g., "palindrome-number").
    ///   - solution: The name of the solution version (e.g., "SolutionV1").
    ///   - inputs: A list of input sizes and their corresponding test data.
    ///   - callingFile: Automatically captured path of the file calling this function (used to locate the folder).
    ///   - runBlock: The closure that runs the actual solution code.
    public static func run<T>(
        challenge: String,
        solution: String,
        inputs: [(size: Int, data: T)],
        callingFile: String = #filePath,
        runBlock: @escaping (T) -> Void
    ) {
        print("📊 Benchmarking: \(challenge) (\(solution))")
        print("==================================================================")
        
        // --- 1. Global Dry-Run Warmup to Eliminate Cold Start Page Spikes ---
        if let firstInput = inputs.first {
            for _ in 0..<500 {
                runBlock(firstInput.data)
            }
            _ = getPhysicalMemoryUsage()
        }
        
        var results: [BenchmarkResult] = []
        let clock = ContinuousClock()
        
        for input in inputs {
            // 2. Local Warm-up to populate heap allocators and JIT compiler
            let warmupCount = BenchmarkConfig.warmupOverride ?? 20
            for _ in 0..<warmupCount {
                runBlock(input.data)
            }
            
            // 3. Measure Absolute Physical Footprint during active steady-state
            // (Matches LeetCode memory reporting exactly)
            let memFootprint = getPhysicalMemoryUsage()
            
            // 4. Determine iterations based on input size
            let iterations = BenchmarkConfig.iterationsOverride ?? (input.size > 1000 ? 50 : 1000)
            
            let start = clock.now
            for _ in 0..<iterations {
                runBlock(input.data)
            }
            let end = clock.now
            
            let duration = end - start
            let totalMicroseconds = Double(duration.components.seconds) * 1_000_000.0 + Double(duration.components.attoseconds) / 1_000_000_000_000.0
            let avgMicroseconds = totalMicroseconds / Double(iterations)
            
            results.append(BenchmarkResult(
                inputSize: input.size,
                averageTimeMicroseconds: avgMicroseconds,
                memoryBytesUsed: Int(memFootprint)
            ))
            
            print("  ✅ Size: \(input.size.formatted()) -> \(formatTime(avgMicroseconds)) | Memory Footprint: \(formatBytes(Int(memFootprint)))")
        }
        
        print("\n📈 Complexity Analysis Chart (Execution Time vs Size)")
        print("------------------------------------------------------------------")
        drawASCIIChart(results: results)
        
        // Save results to local JSON file
        saveResults(challenge: challenge, solution: solution, results: results, callingFile: callingFile)
        print("==================================================================\n")
    }
    
    // MARK: - Modern Memory Tracking API (Apple's task_vm_info / Linux VmRSS)
    private static func getPhysicalMemoryUsage() -> UInt64 {
        #if canImport(Darwin)
        var info = task_vm_info()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        // phys_footprint returns the exact physical memory footprint in bytes
        // (matches Xcode memory gauges and Activity Monitor perfectly)
        return kerr == KERN_SUCCESS ? UInt64(info.phys_footprint) : 0
        #elseif os(Linux)
        // Read /proc/self/status to get VmRSS (Resident Set Size) in bytes
        guard let status = try? String(contentsOfFile: "/proc/self/status", encoding: .utf8) else { return 0 }
        for line in status.components(separatedBy: .newlines) {
            if line.hasPrefix("VmRSS:") {
                let parts = line.split(separator: " ", omittingEmptySubsequences: true)
                if parts.count >= 2, let kb = UInt64(parts[1]) {
                    return kb * 1024 // Convert KB to Bytes
                }
            }
        }
        return 0
        #else
        return 0
        #endif
    }
    
    // MARK: - ASCII Horizontal Bar Graph
    private static func drawASCIIChart(results: [BenchmarkResult]) {
        guard let maxTime = results.map({ $0.averageTimeMicroseconds }).max(), maxTime > 0 else { return }
        
        for result in results {
            let relativeWidth = Int((result.averageTimeMicroseconds / maxTime) * 30.0)
            let bar = String(repeating: "█", count: relativeWidth) + String(repeating: "░", count: 30 - relativeWidth)
            let sizeStr = String(format: "%-8d", result.inputSize)
            let rawTimeStr = formatTime(result.averageTimeMicroseconds)
            let timeStr = String(repeating: " ", count: max(0, 10 - rawTimeStr.count)) + rawTimeStr
            print("  Size \(sizeStr) [\(bar)] \(timeStr)")
        }
    }
    
    // MARK: - Save to JSON Utility
    private static func saveResults(
        challenge: String,
        solution: String,
        results: [BenchmarkResult],
        callingFile: String
    ) {
        let report = BenchmarkReport(
            challenge: challenge,
            solution: solution,
            timestamp: ISO8601DateFormatter().string(from: Date()),
            results: results
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(report) else { return }
        
        // Resolve directory URL of the challenge
        let directoryURL = URL(fileURLWithPath: callingFile).deletingLastPathComponent()
        let fileURL = directoryURL.appendingPathComponent("benchmark_results.json")
        
        do {
            try data.write(to: fileURL)
            let relativePath = fileURL.path.replacingOccurrences(of: FileManager.default.currentDirectoryPath + "/", with: "")
            print("💾 Saved metrics to: \(relativePath)")
        } catch {
            print("⚠️ Warning: Failed to save benchmark results to disk: \(error.localizedDescription)")
        }
    }
    
    private static func formatBytes(_ bytes: Int) -> String {
        if bytes == 0 { return "0 B" }
        let units = ["B", "KB", "MB"]
        var size = Double(bytes)
        var unitIndex = 0
        while size >= 1024 && unitIndex < units.count - 1 {
            size /= 1024.0
            unitIndex += 1
        }
        return String(format: "%.2f %@", size, units[unitIndex])
    }
    
    private static func formatTime(_ microseconds: Double) -> String {
        if microseconds == 0 { return "0 ns" }
        if microseconds < 1.0 {
            return String(format: "%.2f ns", microseconds * 1000.0)
        }
        
        let units = ["µs", "ms", "s"]
        var time = microseconds
        var unitIndex = 0
        while time >= 1000.0 && unitIndex < units.count - 1 {
            time /= 1000.0
            unitIndex += 1
        }
        return String(format: "%.2f %@", time, units[unitIndex])
    }
}
