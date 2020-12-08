import Foundation

public func readFile(_ name: String) -> String? {
    // Try to get filepath for the file in Resources, can result in nil
    guard let filepath = Bundle.main.path(forResource: name, ofType: "") else {
        print("Could not find file in resource: \(name)")
        return nil
    }
    
    // Try to read the contents of the file, can throw an error
    do {
        return try String(contentsOfFile: filepath)
    } catch {
        print("Could not read file \(name) because of \(error)")
        return nil
    }
}

public func readLines(_ name: String) -> [String] {
    guard let content: String = readFile(name) else {
        return []
    }
    
    let lines: [String] = content
        // Remove empty lines at the end
        .trimmingCharacters(in: .whitespacesAndNewlines)
        // Split into separate lines
        .components(separatedBy: .newlines)
    
    if lines.isEmpty {
        print("Empty file \(name)")
    }
    return lines
}

public func readLinesAsInt(_ name: String) -> [Int] {
    let lines: [String] = readLines(name)
    let ints: [Int] = lines.compactMap { Int($0) }
    
    if ints.isEmpty {
        print("No integers found in file \(name)")
    }
    return ints
}
