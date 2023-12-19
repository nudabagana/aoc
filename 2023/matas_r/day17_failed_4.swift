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
var worldWeights  = [[[String:Int]]]()
var maxY : Int = 0
var maxX : Int = 0
let ALL_DIRS: [Direction]  = [.N, .E, .S, .W]
let START_X = 0
let START_Y = 0
var winningPath = [Direction]()

typealias Visit = (y: Int, x:Int, weight: Int, path: [Direction])

func part1(_ input: String) -> String {
    world = input.split(whereSeparator: \.isNewline)
    .map { Array($0) }
    .map { $0.map { c in Int(String(c))! } }
    maxY = world.count - 1
    maxX = world[0].count - 1
    worldWeights = Array(repeating: Array(repeating: [String: Int](), count: maxX+1), count: maxY+1)

    var possibleVisits = [Visit]()
    possibleVisits.append((y:START_Y,x:START_X,weight: 0, path: [.S]))

    while (possibleVisits.count > 0){
        possibleVisits.sort(by: {$0.weight > $1.weight})
        let visit = possibleVisits.removeLast()
        let x = visit.x
        let y = visit.y
        let weight = visit.weight
        let path = visit.path
        if (x == maxX && y == maxY){
            winningPath = path
            break
        }

        let lastDir = path.last!
        if (path.suffix(3).filter {$0 == lastDir}.count < 3){
            let newX = x + lastDir.vals().x
            let newY = y + lastDir.vals().y
            if (newX >= 0 && newX <= maxX && newY >= 0 && newY <= maxY) {
                let newWeight = weight + world[newY][newX]
                let worldWeight = worldWeights[newY][newX][lastDir.rawValue] ?? Int.max
                if (newWeight < worldWeight){
                    worldWeights[newY][newX][lastDir.rawValue] = newWeight
                }
                    var newPath = path
                    if (x != START_X || y != START_Y){
                        newPath.append(lastDir)
                    }
                    possibleVisits.append((y: newY, x: newX, weight: newWeight, path: newPath))
            }
        }
        let turns = lastDir.turns()
        for turn in turns {
            let newX = x + turn.vals().x
            let newY = y + turn.vals().y
            if (newX >= 0 && newX <= maxX && newY >= 0 && newY <= maxY) {
                let newWeight = weight + world[newY][newX]
                let worldWeight = worldWeights[newY][newX][turn.rawValue] ?? Int.max
                if (newWeight < worldWeight){
                    worldWeights[newY][newX][turn.rawValue] = newWeight
                }
                    var newPath = path
                    newPath.append(turn)
                    possibleVisits.append((y: newY, x: newX, weight: newWeight, path: newPath))
            }
        }
        // print("==================================================================================")
        // print(possibleVisits)
        // printWorld()
    }

    // fill(y: 0,x: 0, weight: 0, dir: .E)




    printWorld()


    return "\(worldWeights[maxY][maxX].values)"
}

func dToStr(_ dirs:[Direction]) -> String{
    var str = ""
    for dir in dirs {
        str += dir.rawValue
    }
    return str
}

// func fill(y: Int, x: Int, weight: Int, dir: Direction){
//     var newX = x
//     var newY = y
//     var weight = weight
//     for _ in 1...3 {
//         let move = dir.vals()
//         newX += move.x
//         newY += move.y
//         if (newX < 0 || newY < 0 || newX > maxX || newY > maxY){
//             break
//         }
//         weight += world[newY][newX]
//         if (weight < worldWeights[newY][newX]) {
//             worldWeights[newY][newX] = weight
//         } else {
//             break
//         }
//         let turns = dir.turns()
//         for dir in turns {
//             fill(y: newY, x: newX, weight: weight, dir: dir)
//         }
//     }
//     printWorld()
// }

func printWorld() {
    for y in 0...maxY {
        var line = ""
        for x in 0...maxX {
            line += String(format: "%3d", worldWeights[y][x].values.min() ?? Int.max)
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