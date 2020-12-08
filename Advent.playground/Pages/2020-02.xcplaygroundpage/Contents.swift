import Foundation

//let passwords = [
//    "1-3 a: abcde",
//    "1-3 b: cdefg",
//    "2-9 c: ccccccccc"
//]

let passwords = readLines("input.txt")

let regexp = RegExp(#"^(\d+)-(\d+) (\w): (\w+)$"#)

func parser(s: String) -> (Int, Int, Character, String)? {
    guard
        let matches = regexp.exec(s),
        matches.count == 5,
        let i = Int(matches[1]),
        let j = Int(matches[2]),
        let c = matches[3].first
        else {
            print("Could not parse \(s)")
            return nil
    }
    
    let s = matches[4]
    return (i, j, c, s)
}

func minMaxCheck(format: (min: Int, max: Int, char: Character, password: String)) -> Bool {
    var count = 0
    for char in format.password {
        if char == format.char {
            count += 1
        }
    }
    return format.min ... format.max ~= count
}

let passwordsCorrect1 = passwords
    .compactMap(parser)
    .filter(minMaxCheck)
    .count

print("Passwords correct part 1: \(passwordsCorrect1)")

func eitherOrCheck(format: (pos1: Int, pos2: Int, char: Character, password: String)) -> Bool {
    let chars = Array(format.password)
    let char1: Bool = chars[format.pos1 - 1] == format.char
    let char2: Bool = chars[format.pos2 - 1] == format.char
    
//    print(format, char1, char2, char1 != char2)
    return char1 != char2
}

let passwordsCorrect2 = passwords
    .compactMap(parser)
    .filter(eitherOrCheck)
    .count

print("Passwords correct part 2: \(passwordsCorrect2)")

