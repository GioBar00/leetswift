import Foundation

public enum CLIHelpers {
    /// Resolves a slug from either a raw slug string (e.g. "two-sum") or a directory path (e.g. "./Sources/leetcodes/two-sum")
    public static func resolveSlug(from input: String) -> String {
        let fileManager = FileManager.default
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Resolve absolute/expanding path
        let expandedPath = NSString(string: trimmedInput).expandingTildeInPath
        let url = URL(fileURLWithPath: expandedPath)
        
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue {
            return url.lastPathComponent.lowercased()
        }
        
        // Otherwise return the lowercase input
        return trimmedInput.lowercased()
    }
    
    /// Converts a slug (e.g., "two-sum") into PascalCase (e.g., "TwoSum") for locating Swift test suites
    public static func toPascalCase(slug: String) -> String {
        let components = slug.components(separatedBy: "-")
        return components.map { $0.capitalized }.joined()
    }
    
    /// Formats a `Duration` value into a human-readable string with appropriate units (µs, ms, s).
    public static func formatDuration(_ duration: Duration) -> String {
        let microseconds = Double(duration.components.seconds) * 1_000_000.0
            + Double(duration.components.attoseconds) / 1_000_000_000_000.0
        if microseconds < 1000 {
            return String(format: "%.2f µs", microseconds)
        } else if microseconds < 1_000_000 {
            return String(format: "%.2f ms", microseconds / 1000.0)
        } else {
            return String(format: "%.2f s", microseconds / 1_000_000.0)
        }
    }
}
