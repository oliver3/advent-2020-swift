import Foundation

//let input = """
//nop +0
//acc +1
//jmp +4
//acc +3
//jmp -3
//acc -99
//acc +1
//jmp -4
//acc +6
//""".components(separatedBy: .newlines)
let input = readLines("input.txt")

enum Operation: String {
    case nop, acc, jmp, end
}

struct Instruction: CustomStringConvertible {
    let operation: Operation
    let argument: Int
    
    init?(codeLine: String) {
        let parsed = codeLine.components(separatedBy: .whitespaces)
        
        guard parsed.count == 2,
            let operation = Operation(rawValue: parsed[0]),
            let argument = Int(parsed[1])
            else {
                print("Could not parse instruction", codeLine)
                return nil
        }
        
        self.operation = operation
        self.argument = argument
    }
    
    init(_ operation: Operation, _ argument: Int) {
        self.operation = operation
        self.argument = argument
    }
    
    var description: String {
        "\(operation.rawValue) \(String(format: "%+4d", argument)) "
    }
    
}

enum Status: String {
    case running, finished, illegal, loop
}

struct Device: CustomStringConvertible {
    var instructions: [Instruction]
    var executions: [Int]
    
    var accumulator = 0
    var cursor = 0
    var status = Status.running
    
    
    init(code: [String]) {
        instructions = code.compactMap(Instruction.init) +
            [Instruction(.end, 0)]
        executions = Array(repeating: 0, count: instructions.count)
    }
    
    mutating func change(line: Int) -> Bool {
        let changes: [Operation: Operation] = [.nop: .jmp, .jmp: .nop]
        
        let instruction = instructions[line]
        if let operation = changes[instruction.operation] {
            instructions[line] = Instruction(operation, instruction.argument)
            return true
        } else {
            return false
        }
    }
    
    mutating func step() {
        guard status == .running else {
            print("Device not running")
            return
        }
        
        guard cursor < instructions.count else {
            status = .illegal
            return
        }
        
        guard executions[cursor] == 0 else {
            status = .loop
            return
        }
        
        executions[cursor] += 1
        
        let operation = instructions[cursor].operation
        let argument = instructions[cursor].argument
        
        switch operation {
        case .nop:
            cursor += 1
        case .acc:
            accumulator += argument
            cursor += 1
        case .jmp:
            cursor += argument
        case .end:
            print("Boot code finished! Accumulator is \(accumulator)")
            status = .finished
        }
    }
    
    mutating func run() {
        while status == .running {
//            print(self)
            step()
        }
    }
    
    var description: String {
        let code = instructions
            .enumerated()
            .map { (line, op) in
                (cursor == line ? ">> " : "   ") +
                    "\(String(format:"%5d", line))  \(op)" +
                    String(repeating: ".", count: executions[line])
        }
        .joined(separator: "\n")
        
        return """
        \(code)
        
        Accumulator: \(accumulator)
        
        ==========================
        
        """
    }
}

func findChange(input: [String]) {
    var device = Device(code: input)

    while (device.status == .running) {
        var alternative = device
        if alternative.change(line: alternative.cursor) {
//            print(alternative)
            alternative.run()
            
            if alternative.status == .finished {
                print("Alternative found!", alternative.accumulator)
                break
            } else if alternative.status != .running {
                print("Alternative failed!", alternative.status)
            }
        }
        
        device.step()
    }
}

findChange(input: input)

