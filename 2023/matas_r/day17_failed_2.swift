import Foundation

enum Direction {
    case N
    case E
    case S
    case W

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
                return (y: 0, x: +1)
            case .S:
                return (y: +1, x: 0)
            case .W:
                return (y: 0, x: -1)
        }
    }

    func toStr() -> String {
                switch self {
            case .N:
                return "^"
            case .E:
                return ">"
            case .S:
                return "V"
            case .W:
                return "<"
        }
    }
}

var world = [[Int]]()
var worldWeights  = [[Int]]()
var maxY : Int = 0
var maxX : Int = 0
let ALL_DIRS: [Direction]  = [.N, .E, .S, .W]

func part1(_ input: String) -> String {
    world = input.split(whereSeparator: \.isNewline)
    .map { Array($0) }
    .map { $0.map { c in Int(String(c))! } }
    maxY = world.count - 1
    maxX = world[0].count - 1
    worldWeights = Array(repeating: Array(repeating: Int.max, count: maxX+1), count: maxY+1)
    fill(y: 0,x: 0, weight: 0, dir: .E)
    printWorld()


    return "\(0)"
}

func fill(y: Int, x: Int, weight: Int, dir: Direction){
    var newX = x
    var newY = y
    var weight = weight
    for _ in 1...3 {
        let move = dir.vals()
        newX += move.x
        newY += move.y
        if (newX < 0 || newY < 0 || newX > maxX || newY > maxY){
            break
        }
        weight += world[newY][newX]
        if (weight < worldWeights[newY][newX]) {
            worldWeights[newY][newX] = weight
        } else {
            break
        }
        let turns = dir.turns()
        for dir in turns {
            fill(y: newY, x: newX, weight: weight, dir: dir)
        }
    }
    printWorld()
}

func printWorld() {
    for y in 0...maxY {
        var line = ""
        for x in 0...maxX {
            line += String(format: "%3d", worldWeights[y][x])
            line += "|"
        }
        print(line)
    }
}

func part2(_ input: String) -> String {

    return "\(0)"
}

let input =
#"""
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
"""#