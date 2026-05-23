import Foundation

public enum TestDataLoader {
    /// Dynamically loads content from a file located in the same directory as the calling Swift file.
    /// - Parameters:
    ///   - fileName: The name of the file to load (e.g., "input_large.txt").
    ///   - callingFile: Automatically captured path of the file calling this function.
    /// - Returns: The string contents of the file, or nil if the file could not be read.
    public static func loadString(fileName: String, callingFile: String = #filePath) -> String? {
        let directoryURL = URL(fileURLWithPath: callingFile).deletingLastPathComponent()
        let fileURL = directoryURL.appendingPathComponent(fileName)
        return try? String(contentsOf: fileURL, encoding: .utf8)
    }
}
