import Foundation

//let input = """
//abc
//
//a
//b
//c
//
//ab
//ac
//
//a
//a
//a
//a
//
//b
//"""

let input = readFile("input.txt") ?? ""

func anyone(_ group: String) -> Int {
    return Set(group).subtracting("\n").count
}

func everyone(_ group: String) -> Int {
    let persons = group.components(separatedBy: "\n")
        .map(Array.init)
        .filter { $0.count > 0 }
    print(persons)
    
    // Answers to check, no need to check a-z,
    // because if the first person did not answer it, it will be false anyway
    let answers = persons[0]
    
    return answers.map { answer in
//        persons.map { person in
//            person.contains(answer)
//        }.allSatisfy { $0 } ? 1 : 0
        persons.allSatisfy { $0.contains(answer) } ? 1 : 0
    }.reduce(0, +)
}

let groups = input.components(separatedBy: "\n\n")
let anyoneYesAnswers = groups.map(anyone)
print("ANYONE", anyoneYesAnswers.reduce(0, +))

let allYesAnswers = groups.map(everyone)
print("EVERYONE", allYesAnswers.reduce(0, +))





