//let input = """
//..##.......
//#...#...#..
//.#....#..#.
//..#.#...#.#
//.#...##..#.
//..#.##.....
//.#.#.#....#
//.#........#
//#.##...#...
//#...##....#
//.#..#...#.#
//""".components(separatedBy: .newlines)

let input = readLines("input.txt")

let map = input.map(Array.init)

func countTrees(slope: (right: Int, down: Int)) -> Int {
    var position = (right: 0, down: 0)
    var trees = 0

    repeat {
//        print(position)
        let row = map[position.down]
        let square = row[position.right % row.count]
//        print(square)
        let tree: Bool = square == ("#" as Character)
        trees += (tree ? 1 : 0)
        position = (right: position.right + slope.right, down: position.down + slope.down)
    } while (position.down < map.count)
    
    return trees
}



let trees = countTrees(slope: (right: 3, down: 1))
print("Encountered \(trees) trees")

let slopes = [
    (right: 1, down: 1),
    (right: 3, down: 1),
    (right: 5, down: 1),
    (right: 7, down: 1),
    (right: 1, down: 2)
]

let treesCounted = slopes.map(countTrees)
print(treesCounted)

let answer = treesCounted.reduce(1, *)
print(answer)
