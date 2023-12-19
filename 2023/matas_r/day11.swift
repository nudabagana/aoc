import Foundation

var doubleYs = [Int]()
var doubleXs = [Int]()
var world  = [[Character]]()
var maxX = 0
var maxY = 0
var galaxies = [(y: Int, x: Int)]()

func part1(_ input: String) -> String {
    world =  input
    .split(whereSeparator: \.isNewline)
    .map { Array($0) }
    maxY = world.count - 1
    maxX = world[0].count - 1
    for y in 0...maxY {
        var noGalaxy = true
        for x in 0...maxX {
            if (world[y][x] == "#"){
                noGalaxy = false
                galaxies.append((y:y, x:x))
            }
        }
        if (noGalaxy){
            doubleYs.append(y)
        }
    }
    for x in 0...maxX {
        var noGalaxy = true
        for y in 0...maxY {
        if (world[y][x] == "#"){
            noGalaxy = false
            }
        }
        if (noGalaxy){
            doubleXs.append(x)
        }
    }

    let pairs = makePears(galaxies)
    var distanceSum = 0
    for pair in pairs {
        let minX = min(pair.0.x, pair.1.x)
        let maxX = max(pair.0.x, pair.1.x)
        let minY = min(pair.0.y, pair.1.y)
        let maxY = max(pair.0.y, pair.1.y)
        let doubleXCount = doubleXs.filter {$0 > minX && $0 < maxX}.count
        let doubleYCount = doubleYs.filter {$0 > minY && $0 < maxY}.count
        let distance = maxX - minX + maxY - minY + (doubleXCount + doubleYCount)
        distanceSum += distance
    }

    return "\(distanceSum)"
}

func part2(_ input: String) -> String {
        world =  input
    .split(whereSeparator: \.isNewline)
    .map { Array($0) }
    maxY = world.count - 1
    maxX = world[0].count - 1
    for y in 0...maxY {
        var noGalaxy = true
        for x in 0...maxX {
            if (world[y][x] == "#"){
                noGalaxy = false
                galaxies.append((y:y, x:x))
            }
        }
        if (noGalaxy){
            doubleYs.append(y)
        }
    }
    for x in 0...maxX {
        var noGalaxy = true
        for y in 0...maxY {
        if (world[y][x] == "#"){
            noGalaxy = false
            }
        }
        if (noGalaxy){
            doubleXs.append(x)
        }
    }

    let pairs = makePears(galaxies)
    var distanceSum = 0
    for pair in pairs {
        let minX = min(pair.0.x, pair.1.x)
        let maxX = max(pair.0.x, pair.1.x)
        let minY = min(pair.0.y, pair.1.y)
        let maxY = max(pair.0.y, pair.1.y)
        let doubleXCount = doubleXs.filter {$0 > minX && $0 < maxX}.count * 999999
        let doubleYCount = doubleYs.filter {$0 > minY && $0 < maxY}.count * 999999
        let distance = maxX - minX + maxY - minY + doubleXCount + doubleYCount
        distanceSum += distance
    }

    return "\(distanceSum)"
}

let input =
#"""
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
"""#

func makePears<T>(_ array: [T]) -> [(T, T)] {
    var pairs = [(T, T)]()
    for i in 0..<array.count {
        for j in i+1..<array.count {
            pairs.append((array[i], array[j]))
        }
    }
    return pairs
}

let CORNERS: [Character] = ["7", "J", "L", "F"]
let ALL_DIRS:  [Direction] = [.N, .E, .S, .W]

enum Turn: String {
    case NE = "7"
    case SW = "J"
    case SE = "L"
    case NW = "F"
}

enum Direction: String {
    case N = "U"
    case E = "R"
    case S = "D"
    case W = "L"

    static func fromInt(_ nr: Int) -> Direction {
        switch nr {
            case 0:
                return .E
            case 1:
                return .S
            case 2:
                return .W
            default:
                return .N
        }
    }

    func turns() -> [Direction] {
        switch self {
            case .N:
                return [.E, .W]
            case .E:
                return [.N, .S]
            case .S:
                return [.E, .W]
            case .W:
                return [.N, .S]
        }
    }

    func vals() -> (y: Int, x: Int) {
        switch self {
            case .N:
                return (y: -1, x: 0)
            case .E:
                return (y: 0, x: 1)
            case .S:
                return (y: 1, x: 0)
            case .W:
                return (y: 0, x: -1)
        }
    }

    func canMoves() -> [Character] {
        switch self {
            case .N:
                return ["|", "F", "7"]
            case .E:
                return ["-", "J", "7"]
            case .S:
                return ["|", "L", "J"]
            case .W:
                return ["-", "L", "F"]
        }
    }
}

extension Array {
    subscript(s index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}