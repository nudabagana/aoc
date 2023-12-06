import Foundation

func day3part1(_ input: String) -> String {
    let matrix = input
    .split(whereSeparator: \.isNewline)
    .map { Array($0) }

    var validNumbers = [Int]()

    for i in 0..<matrix.count {
        var word = ""
        let lineLen = matrix[i].count
        for i2 in 0..<lineLen {
            let char = matrix[i][i2]
            if (char.isNumber){
                if (Int(word) != nil){
                    word += String(char)
                } else {
                    word = String(char)
                }
            }
            if (Int(word) != nil && (i2 >= lineLen-1 || !matrix[i][i2+1].isNumber)){
                let wordLen = word.count-1
                var charsAround = [Character]()
                let up = matrix.indices.contains(i-1)
                let down = matrix.indices.contains(i+1)
                let left = matrix[i].indices.contains(i2-wordLen-1)
                let right = matrix[i].indices.contains(i2+1)
                // print("up: \(up) | down: \(down) | left: \(left) | right: \(right)")
                if (up){
                    charsAround.append(contentsOf: matrix[i-1][i2-wordLen...i2])
                }
                if (down){
                    charsAround.append(contentsOf: matrix[i+1][i2-wordLen...i2])
                }
                if (left) {
                    charsAround.append(matrix[i][i2-wordLen-1])
                    if (up) {
                        charsAround.append(matrix[i-1][i2-wordLen-1])
                    }
                    if (down){
                        charsAround.append(matrix[i+1][i2-wordLen-1])
                    }
                }
                if (right){
                    charsAround.append(matrix[i][i2+1])
                    if (up) {
                        charsAround.append(matrix[i-1][i2+1])
                    }
                    if (down){
                        charsAround.append(matrix[i+1][i2+1])
                    }
                }
                
                let validChars = charsAround.filter { $0 != "."}
                if (validChars.count > 0){
                    validNumbers.append(Int(word)!)
                }
                word = ""
            }
        }
    }
    print(validNumbers)
    let sum = validNumbers.reduce(0,+)
    return String(sum)
}

// check all squares for numbers
// call getNumber
// add numbs to Array
// filter duplicate by start idx
// if 2 numbers, multiply

func day3part2(_ input: String) -> String {
    let matrix = input
    .split(whereSeparator: \.isNewline)
    .map { Array($0) }

    var validNumbers = [Int]()

    for i in 0..<matrix.count {
        let lineLen = matrix[i].count
        for i2 in 0..<lineLen {
            if (matrix[i][i2] == "*"){
                print("\(i)_\(i2)")
                let numberIdxs = getNumberIndexes(matrix,i,i2)
                print(numberIdxs)
                let numbers  = numberIdxs.map { getFullNumber(matrix, $0) }
                .reduce(into: [String: Int](), { dict, numb in
                dict[numb.0] = numb.1 }).values.map { Int($0) }
                print(numbers)
                if (numbers.count == 2){
                    let t = numbers[0] * numbers[1]
                    print(numbers[0])
                    print(t)
                    validNumbers.append(numbers[0] * numbers[1])
                }
            }
        }
    }
    print(validNumbers)
    let sum = validNumbers.reduce(0,+)

    return String(sum)
}

func getNumberIndexes(_ matrix: [[Substring.Element]], _ i: Int, _ i2: Int) -> [(Int, Int)] {
    var idxs = [(Int, Int)]()
    for j in -1...1 {
        for j2 in -1...1 {
            if (matrix.indices.contains(i+j) && matrix[i+j].indices.contains(i2+j2) && matrix[i+j][i2+j2].isNumber){
                idxs.append((i+j, i2+j2))
            }
        }
    }
    return idxs
}

func getFullNumber(_ matrix: [[Substring.Element]], _ idxs: (Int, Int)) -> (String, Int) {
    let i = idxs.0
    var i2 = idxs.1
    while (matrix[i].indices.contains(i2-1) && matrix[i][i2-1].isNumber){
        i2 -= 1
    }
    let startStr = "\(i)_\(i2)"
    var word = "" + String(matrix[i][i2])
    while (matrix[i].indices.contains(i2+1) && matrix[i][i2+1].isNumber){
        i2 += 1
        word += String(matrix[i][i2])
    }

    return (startStr,Int(word)!)
}


let input =
"""
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

let output = day3part2(day3Input)
print(output)