import Foundation

//let input = """
//light red bags contain 1 bright white bag, 2 muted yellow bags.
//dark orange bags contain 3 bright white bags, 4 muted yellow bags.
//bright white bags contain 1 shiny gold bag.
//muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
//shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
//dark olive bags contain 3 faded blue bags, 4 dotted black bags.
//vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
//faded blue bags contain no other bags.
//dotted black bags contain no other bags.
//""".components(separatedBy: .newlines)

//let input = """
//shiny gold bags contain 2 dark red bags.
//dark red bags contain 2 dark orange bags.
//dark orange bags contain 2 dark yellow bags.
//dark yellow bags contain 2 dark green bags.
//dark green bags contain 2 dark blue bags.
//dark blue bags contain 2 dark violet bags.
//dark violet bags contain no other bags.
//""".components(separatedBy: .newlines)

let input = readLines("input.txt")

func parseRule(_ s: String) -> (bag: String, bags: [(n: Int, bag: String)]) {
    let contain = s.components(separatedBy: " bags contain ")
    
    guard contain.count == 2 else {
        print("Could not parse rule", s, contain)
        return (s, [])
    }
    
    let bag = contain[0]
    
    let bags = contain[1]
        .dropLast()
        .components(separatedBy: ", ")
        .compactMap(parseContainsBags)
    
    return (bag, bags)
}

func parseContainsBags(_ s: String) -> (n: Int, bag: String)? {
    if s.starts(with: "no ") {
        return nil
    }
    
    let parts = s.components(separatedBy: .whitespaces)
    
    guard parts.count == 4 else {
        print("Could not parse bag", s, parts)
        return nil
    }
    
    if let n = Int(parts[0]) {
        return (n, "\(parts[1]) \(parts[2])")
    } else {
        return nil
    }
}

let bagRules = input.map(parseRule)

var outerBagsDict: [String: Set<String>] = [:]

for (bag, innerBags) in bagRules {
    for (_, innerBag) in innerBags {
        outerBagsDict[innerBag, default: []].insert(bag)
    }
}

//print(outerBagsDict)

func findAllOuterBags(of bag: String) -> [String] {
    guard let outerBags = outerBagsDict[bag] else {
        return []
    }

    return outerBags.reduce([]) { acc, outerBag in
        return acc + [outerBag] + findAllOuterBags(of: outerBag)
    }
}


let answer1Set = Set(findAllOuterBags(of: "shiny gold"))
print("SHINY GOLD IN", answer1Set, " : ", answer1Set.count)


var innerBagsDict = Dictionary(uniqueKeysWithValues: bagRules)

func countBags(in bag: String) -> Int {
    guard let innerBags = innerBagsDict[bag] else {
        return 0
    }
    
    return innerBags.reduce(0) { (acc, innerBag) in
        acc + innerBag.n * (1 + countBags(in: innerBag.bag))
    }
}
print(countBags(in: "shiny gold"))
