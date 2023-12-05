import Foundation

func day1part1(_ input: String) -> String {
    let result = input
    .split(whereSeparator: \.isNewline)
    .map { Array($0) }
    .map{ "\(findFirstNumb($0))\(findFirstNumb($0, true))" }
    .map { Int($0)! }
    .reduce(0,+)

    return String(result)
}

func findFirstNumb(_ chars: [Character], _ reverse: Bool = false) -> Int {
    let dict = reverse ? REVERSE_VALUE_DICT : VALUE_DICT
    let chars = reverse ? chars.reversed() : chars
    for i in 0...chars.count {
        var word = ""
        for i2 in 0...min(4,chars.count-i-1) {
            word += String(chars[i+i2])
            if (dict.keys.contains(word)) {
                return dict[word]!
            }
        }
    }
    return 999999999
}

let VALUE_DICT : [String: Int] = [
    "0": 0,
    "zero": 0,
    "1": 1,
    "one": 1,
    "2": 2,
    "two": 2,
    "3": 3,
    "three": 3,
    "4": 4,
    "four": 4,
    "5": 5,
    "five": 5,
    "6": 6,
    "six": 6,
    "7": 7,
    "seven": 7,
    "8": 8,
    "eight": 8,
    "9": 9,
    "nine": 9,
]

let REVERSE_VALUE_DICT  = Array(VALUE_DICT).reduce(into: [String: Int](), { dict, keyVal in
    let (key, value) = keyVal
    dict[String(key.reversed())] = value
})

// failed attempt - Replacing one number can break another
// func replaceNumbers(_ str: String) -> String {
//     var str = str
//     for (of, with) in REPLACEMENTS {
//         str = str.replacingOccurrences(of: of , with: with)
//     }
//     return str
// }
// let REPLACEMENTS = [
//     ("zero", "0"),
//     ("one", "1"),
//     ("two", "2"),
//     ("three", "3"),
//     ("four", "4"),
//     ("five", "5"),
//     ("six", "6"),
//     ("seven", "7"),
//     ("eight", "8"),
//     ("nine", "9"),
// ]

let input =
"""
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"""

let output = day1part1(day1Input)
print(output)