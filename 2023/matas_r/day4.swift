import Foundation

func day4part1(_ input: String) -> String {
    let numbers = input
    .split(whereSeparator: \.isNewline)
    .map { $0.split(separator: ":")[1] }
    .map { ($0.split(separator: "|")[0],$0.split(separator: "|")[1] )}
    .map { ($0.0.split(separator: " "), $0.1.split(separator: " ")) }
    .map { arrs in arrs.1.filter { arrs.0.contains($0) }}
    .map { $0.count - 1}
    .filter { $0 >= 0 }

    let points = numbers.map { pow(2, $0) }
    .reduce(0,+)

    return "\(points)"
}



func day4part2(_ input: String) -> String {
      let numbers = input
    .split(whereSeparator: \.isNewline)
    .map { $0.split(separator: ":")[1] }
    .map { ($0.split(separator: "|")[0],$0.split(separator: "|")[1] )}
    .map { ($0.0.split(separator: " "), $0.1.split(separator: " ")) }
    .map { arrs in arrs.1.filter { arrs.0.contains($0) }}
    .map { $0.count }

    var sum = 0
    var mul = [Int:Int]()
    for i in 0..<numbers.count {
        sum += 1
        if (mul.keys.contains(i)){
            sum += mul[i]!
        }
        if (numbers[i] > 0){
            for i2 in 1...numbers[i] {
                mul[i+i2] = (mul[i+i2] ?? 0) + 1 * (1 + (mul[i] ?? 0))
            }
        }
    }

    print(mul)
    return "\(sum)"
}

let input =
"""
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""

// let output = day4part1(day4Input)
// let output = day4part2(input)
let output = day4part2(day4Input)
print(output)