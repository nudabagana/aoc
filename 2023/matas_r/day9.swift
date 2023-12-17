import Foundation

func part1(_ input: String) -> String {
    let lines = input.components(separatedBy: "\n")
    .map { $0.split( separator: " ") }
    .map { Array($0) }
    .map { $0.map { c in Int(c)! } }

    var sum = 0
    for line in lines {
        var stack = [[Int]]()
        stack.append(line)
        var currLine = line
        while (currLine.first {$0 != 0 } != nil){
            var newLine = [Int]()
            for i in 0..<(currLine.count-1) {
                newLine.append(currLine[i+1] - currLine[i])
            }
            stack.append(newLine)
            currLine = newLine
        }
        var prevNumb = 0
        while (stack.count > 0){
            let currLine = stack.popLast()
            prevNumb += currLine!.last!
        }
        sum += prevNumb
    }
    return "\(sum)"
}


func part2(_ input: String) -> String {
    let lines = input.components(separatedBy: "\n")
    .map { $0.split( separator: " ") }
    .map { Array($0) }
    .map { $0.map { c in Int(c)! } }

    var sum = 0
    for line in lines {
        var stack = [[Int]]()
        stack.append(line)
        var currLine = line
        while (currLine.first {$0 != 0 } != nil){
            var newLine = [Int]()
            for i in 0..<(currLine.count-1) {
                newLine.append(currLine[i+1] - currLine[i])
            }
            stack.append(newLine)
            currLine = newLine
        }
        var prevNumb = 0
        while (stack.count > 0){
            let currLine = stack.popLast()
            prevNumb = currLine!.first! - prevNumb
        }
        sum += prevNumb
    }

    return "\(sum)"
}

let input =
"""
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
"""