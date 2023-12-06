import Foundation

let R_LIMIT = 12
let G_LIMIT = 13
let B_LIMIT = 14

typealias GameStat = (nr:Int, sets: [(r:Int,g:Int,b:Int)])

func day2part1(_ input: String) -> String {
    let result = input
    .split(whereSeparator: \.isNewline)
    .map { toGameStat(String($0)) }
    .filter { game in 
    game.sets.first( where: { gameSet in
     gameSet.b > B_LIMIT || gameSet.g > G_LIMIT || gameSet.r > R_LIMIT }) == nil
    }.map { $0.nr }
    .reduce(0,+)

    return String(result)
}

func day2part2(_ input: String) -> String {
    let result = input
    .split(whereSeparator: \.isNewline)
    .map { toGameStat(String($0)) }
    .map { game in 
        let r = game.sets.map { $0.r }.max()!
        let g = game.sets.map { $0.g }.max()!
        let b = game.sets.map { $0.b }.max()!
        return r * g * b
    }.reduce(0,+)

    return String(result)
}

func toGameStat(_ line: String) -> GameStat {
    let parts = line.split(separator: ":")
    let nr = Int(parts[0].split(separator: " ")[1])!
    let setsStr = parts[1].split(separator: ";")
    var gameStat: GameStat = (nr,sets: [])
    for setStr in setsStr {
        var clrObj = (r: 0, g:0, b:0)
        let clrs = setStr.split(separator: ",")
        for clr in clrs {
            let clrParts = clr.split(separator: " ")
            if (clrParts[1] == "red"){
                clrObj.r = Int(clrParts[0])!
            }else if (clrParts[1] == "green"){
                clrObj.g = Int(clrParts[0])!
            }else {
                clrObj.b = Int(clrParts[0])!
            }
        }
        gameStat.sets.append(clrObj)
    }
    return gameStat
}

let input =
"""
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"""

let output = day2part2(day2Input)
print(output)