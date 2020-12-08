import Foundation

func calculateSeatId(_ seat: String) -> Int? {
    let seatBinary = seat
        .replacingOccurrences(of: "B", with: "1")
        .replacingOccurrences(of: "F", with: "0")
        .replacingOccurrences(of: "R", with: "1")
        .replacingOccurrences(of: "L", with: "0")
    
    return Int(seatBinary, radix: 2)
}

//func calculateSeat(_ seat: String) -> (row: Int, col: Int, id: Int)? {
//    guard let id = calculateSeatId(seat) else {
//        return nil
//    }
//
//    let row = id / 8
//    let col = id % 8
//
//    return (row, col, id)
//}

// row 44, column 5 : ID 357
//assert(calculateSeat("FBFBBFFRLR")! == (44, 5, 357))

assert(calculateSeatId("FBFBBFFRLR")! == 357)

let seats = readLines("input.txt")
let seatIds = seats.compactMap(calculateSeatId)
print("MAX SEAT", seatIds.max() ?? -1)

let srtd = seatIds.sorted()
for i in 0 ... srtd.count - 2 {
    if srtd[i] + 1 != srtd[i+1] {
        print("EMPTY SEAT", srtd[i] + 1)
    }
}
