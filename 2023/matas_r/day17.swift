import Foundation

enum Direction: String {
    case N = "N"
    case E = "E"
    case S = "S"
    case W = "W"

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
}

var world = [[Int]]()
var seen  = [String]()
var maxY : Int = 0
var maxX : Int = 0
let ALL_DIRS: [Direction]  = [.N, .E, .S, .W]
let START_X = 0
let START_Y = 0

typealias Visit = (y: Int, x:Int, weight: Int, dir: Direction, n: Int)

func part1(_ input: String) -> String {
    world = input.split(whereSeparator: \.isNewline)
    .map { Array($0) }
    .map { $0.map { c in Int(String(c))! } }
    maxY = world.count - 1
    maxX = world[0].count - 1

    var possibleVisits = [Visit]()

    possibleVisits.append((y:START_Y,x:START_X,weight: 0, dir: .E, n: 0))
    possibleVisits.append((y:START_Y,x:START_X,weight: 0, dir: .S, n: 0))

    while (possibleVisits.count > 0) {
        possibleVisits.sort(by: { $0.weight < $1.weight })
        let visit = possibleVisits.removeFirst()

        let x = visit.x
        let y = visit.y
        let weight = visit.weight
        let dir = visit.dir
        let n = visit.n

        if (x == maxX && y == maxY){
            return "\(weight)"
        }

        let asStr = "\(x)_\(y)\(dir.rawValue)\(n)"
        if (seen.contains(asStr)){
            continue
        }
        seen.append(asStr)

        if (n < 3) {
            let newX = x + dir.vals().x
            let newY = y + dir.vals().y

            if (newX >= 0 && newX <= maxX && newY >= 0 && newY <= maxY) {
                let newWeight = weight + world[newY][newX]
                possibleVisits.append((y: newY, x: newX, weight: newWeight, dir: dir, n + 1))
            }
        }

        let turns = dir.turns()
        for turn in turns {
            let newX = x + turn.vals().x
            let newY = y + turn.vals().y
            if (newX >= 0 && newX <= maxX && newY >= 0 && newY <= maxY) {
                let newWeight = weight + world[newY][newX]
                possibleVisits.append((y: newY, x: newX, weight: newWeight, dir: turn, 1))
            }
        }
    }

    return "\(0)"
}


func part2(_ input: String) -> String {
    world = input.split(whereSeparator: \.isNewline)
    .map { Array($0) }
    .map { $0.map { c in Int(String(c))! } }
    maxY = world.count - 1
    maxX = world[0].count - 1

    var possibleVisits = [Visit]()

    possibleVisits.append((y:START_Y,x:START_X,weight: 0, dir: .E, n: 0))
    possibleVisits.append((y:START_Y,x:START_X,weight: 0, dir: .S, n: 0))

    while (possibleVisits.count > 0) {
        possibleVisits.sort(by: { $0.weight < $1.weight })
        let visit = possibleVisits.removeFirst()
        let x = visit.x
        let y = visit.y
        let weight = visit.weight
        let dir = visit.dir
        let n = visit.n

        if (x == maxX && y == maxY && n >= 4){
            return "\(weight)"
        }

        let asStr = "\(x)_\(y)\(dir.rawValue)\(n)"
        if (seen.contains(asStr)){
            continue
        }
        seen.append(asStr)

        if (n < 10) {
            let newX = x + dir.vals().x
            let newY = y + dir.vals().y

            if (newX >= 0 && newX <= maxX && newY >= 0 && newY <= maxY) {
                let newWeight = weight + world[newY][newX]
                possibleVisits.append((y: newY, x: newX, weight: newWeight, dir: dir, n + 1))
            }
        }
        if (n >= 4){
            let turns = dir.turns()
            for turn in turns {
                let newX = x + turn.vals().x
                let newY = y + turn.vals().y
                if (newX >= 0 && newX <= maxX && newY >= 0 && newY <= maxY) {
                    let newWeight = weight + world[newY][newX]
                    possibleVisits.append((y: newY, x: newX, weight: newWeight, dir: turn, 1))
                }
            }

        }
    }

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