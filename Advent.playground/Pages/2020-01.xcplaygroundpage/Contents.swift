import Foundation

//let numbers = [ 1721, 979, 366, 299, 675, 1456 ]
let numbers = readLinesAsInt("input.txt")

if let result = multiplyTwoEntriesThatSum2020(numbers) {
    print("🎉 \(result)")
} else {
    print("🤷‍♂️")
}

func multiplyTwoEntriesThatSum2020(_ numbers: [Int]) -> Int? {
    for n1 in numbers {
        for n2 in numbers {
            for n3 in numbers {
                if n1 + n2 + n3 == 2020 {
                    return n1 * n2 * n3
                }
            }
        }
    }
    return nil
}


