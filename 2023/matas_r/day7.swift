import Foundation

let CARD_VALUE: [Character: Int] = [
    "A": 14,
    "K": 13,
    "Q": 12,
    // "J" : 11, uncomment for part1
    "T": 10,
    "9": 9,
    "8": 8,
    "7": 7,
    "6": 6,
    "5": 5,
    "4": 4,
    "3": 3, 
    "2" : 2,
    "J" : 1, // comment for part 1
]

enum CustomError: Error {
    case customError(String)
}

func part1(_ input: String) throws -> String {
    if (CARD_VALUE["J"] != 11){
        throw CustomError.customError("Look up!")
    }

    let players = input.split(whereSeparator: \.isNewline)
    .map { $0.split(separator: " ") }
    .map { (hand: Array($0[0]), bid: Int($0[1])!)}
    .map { (hand: $0.hand.sorted(by: handSort), bid: $0.bid, ogHand: $0.hand)}
    .map { (powerLevel: calcHandPower($0.hand, $0.ogHand), bid: $0.bid ) }
    .sorted(by: { $0.powerLevel > $1.powerLevel })

    let sum = Array(zip((1...players.count).reversed(), players.map { $0.bid }))
    .map { $0.0 * $0.1}
    .reduce(0,+)
 
    return "\(sum)"
}

func part2(_ input: String) throws -> String {
    if (CARD_VALUE["J"] != 1){
        throw CustomError.customError("Look up!")
    }
    let players = input.split(whereSeparator: \.isNewline)
    .map { $0.split(separator: " ") }
    .map { (hand: Array($0[0]), bid: Int($0[1])!)}
    .map { (hand: $0.hand.sorted(by: handSort), bid: $0.bid, ogHand: $0.hand)}
    .map { (powerLevel: calcPowerLevelWithJokers($0.hand, $0.ogHand), bid: $0.bid) }
    .sorted(by: { $0.powerLevel > $1.powerLevel })

    let sum = Array(zip((1...players.count).reversed(), players.map { $0.bid }))
    .map { $0.0 * $0.1}
    .reduce(0,+)
 
    return "\(sum)"
}

func handSort(a: Character, b: Character) -> Bool {
    CARD_VALUE[a]! > CARD_VALUE[b]!
}

let COMBO_MUL = 10000000000
let CARD_0_MUL = COMBO_MUL / 100
let CARD_1_MUL = CARD_0_MUL / 100
let CARD_2_MUL = CARD_1_MUL / 100
let CARD_3_MUL = CARD_2_MUL / 100
let CARD_4_MUL = CARD_3_MUL / 100
func calcHandPower(_ h: [Character], _ oh: [Character])-> Int {
    var powerLevel = 0
    if (h[0] == h[1] && h[0] == h[2] && h[0] == h[3] && h[0] == h[4]){
        // 5
        powerLevel += COMBO_MUL * 7
    }else if ((h[0] == h[1] && h[0] == h[2] && h[0] == h[3]) || 
              (h[1] == h[2] && h[1] == h[3] && h[1] == h[4])){
        // 4
        powerLevel += COMBO_MUL * 6
    }else if ((h[0] == h[1] && h[0] == h[2] && h[3] == h[4]) ||
              (h[0] == h[1] && h[2] == h[3] && h[2] == h[4])){
        // House
        powerLevel += COMBO_MUL * 5
    }else if ((h[0] == h[1] && h[0] == h[2]) ||
              (h[1] == h[2] && h[1] == h[3]) || 
              (h[2] == h[3] && h[2] == h[4])){
        // 3
        powerLevel += COMBO_MUL * 4
    }else if ((h[0] == h[1] && h[2] == h[3]) ||
              (h[0] == h[1] && h[3] == h[4]) || 
              (h[1] == h[2] && h[3] == h[4])){
        // 2 of 2
        powerLevel += COMBO_MUL * 3
    }else if ((h[0] == h[1]) ||
              (h[1] == h[2]) ||
              (h[2] == h[3]) || 
              (h[3] == h[4])){
        // 2 
        powerLevel += COMBO_MUL * 2
    }else {
        // High
        powerLevel += COMBO_MUL * 1
    }

    powerLevel += CARD_VALUE[oh[0]]! * CARD_0_MUL
    powerLevel += CARD_VALUE[oh[1]]! * CARD_1_MUL
    powerLevel += CARD_VALUE[oh[2]]! * CARD_2_MUL
    powerLevel += CARD_VALUE[oh[3]]! * CARD_3_MUL
    powerLevel += CARD_VALUE[oh[4]]! * CARD_4_MUL

    return powerLevel
}

let CARD_TYPES = CARD_VALUE.keys
func calcPowerLevelWithJokers(_ h: [Character], _ oh: [Character])-> Int {
    var powerLvl = [calcHandPower(h, oh)]
    for char in CARD_TYPES {
        let replacedH = Array(String(h).replacingOccurrences(of: "J", with: String(char))).sorted(by: handSort)
        powerLvl.append(calcHandPower(replacedH, oh))
    }
    return powerLvl.max()!
}

let input =
"""
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""