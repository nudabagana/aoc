import Foundation

var world  = [[Character]]()
var maxX = 0
var maxY = 0
var x = 0
var y = 0
var nextDir = Direction.N

func part1(_ input: String) -> String {
    world =  input
    .split(whereSeparator: \.isNewline)
    .map { Array($0) }
    maxY = world.count - 1
    maxX = world[0].count - 1
    
    var startX = 0
    var startY = 0
    for y in 0...maxY {
        for x in 0...maxX {
            if (world[y][x] == "S"){
                startX = x
                startY = y
            }
        }
    }
    x = startX
    y = startY
    
    for dir in ALL_DIRS {
        let nextX = startX + dir.vals().x
        let nextY = startY + dir.vals().y
        if (dir.canMoves().contains(where: {$0 == world[s:nextY]?[s: nextX]} )){
            nextDir = dir
        }
    }

    var len = 1
    move()
    while (x != startX || y != startY){
        move()
        len += 1
    }
    let halfLen = len/2

    return "\(halfLen)"
}

func move(){
    x += nextDir.vals().x
    y += nextDir.vals().y
    let char = world[y][x]
    if (CORNERS.contains(char)){
        corners.append((y: y, x:x))
    }
    switch char {
        case "-", "|":
            return
        case "7":
            nextDir = nextDir == .E ? .S : .W
            return
        case "J":
            nextDir = nextDir == .E ? .N : .W
            return
        case "L":
            nextDir = nextDir == .S ? .E : .N
            return
        case "F":
            nextDir = nextDir == .N ? .E : .S
            return
        default:
            return
    }
}

var corners = [(y:Int, x: Int)]()
func part2(_ input: String) -> String {
    world =  input
    .split(whereSeparator: \.isNewline)
    .map { Array($0) }
    maxY = world.count - 1
    maxX = world[0].count - 1
    
    var startX = 0
    var startY = 0
    for y in 0...maxY {
        for x in 0...maxX {
            if (world[y][x] == "S"){
                startX = x
                startY = y
            }
        }
    }
    x = startX
    y = startY
    
    for dir in ALL_DIRS {
        let nextX = startX + dir.vals().x
        let nextY = startY + dir.vals().y
        if (dir.canMoves().contains(where: {$0 == world[s:nextY]?[s: nextX]} )){
            nextDir = dir
        }
    }

    corners.append((y: startY, x: startX))
    var len = 1
    move()
    while (x != startX || y != startY){
        len += 1
        move()
    }
    corners.append((y: startY, x: startX))

    var sumX = 0
    var sumY = 0
    for i in 0..<corners.count-1 {
        sumX += corners[i].x * corners[i+1].y
        sumY += corners[i].y * corners[i+1].x
    }

    let areaSum = abs(sumX-sumY) / 2
    let offset = len/2 - 1

    return "\(areaSum - offset)"
}

let input =
#"""
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
"""#

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