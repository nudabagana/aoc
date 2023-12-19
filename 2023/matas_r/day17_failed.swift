import Foundation

enum Direction {
    case N
    case E
    case S
    case W

    func opposite() -> Direction {
        switch self {
            case .N:
                return .S
            case .E:
                return .W
            case .S:
                return .N
            case .W:
                return .E
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

func nextX(_ dir:Direction) -> Int {
    switch dir {
        case .N, .S:
            return 0
        case .E:
            return 1
        case .W:
            return -1
    }
}

func nextY(_ dir:Direction) -> Int {
    switch dir {
        case .E, .W:
            return 0
        case .N:
            return -1
        case .S:
            return 1
    }
}

var world : [[Int]] = [[Int]]()
var worldWeights : [[Int]] = [[Int]]()
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
    world[0][0] = 0
    populateWeights(y: maxY, x: maxX, cost: 0, lastDirs: [], visited: [])

    for y in 0...maxY {
        var line = ""
        for x in 0...maxX {
            line += String(format: "%3d", worldWeights[y][x])
            line += "|"
        }
        print(line)
    }
    print("-------------------------------------------------------")
    // let path = buildPath(y: 0, x: 0, steps: [])
    // for y in 0...maxY {
    //     var line = ""
    //     for x in 0...maxX {
    //         let pathNode = path.first {$0.x == x && $0.y == y}
    //         if (pathNode != nil){
    //             line += " \(pathNode!.dir.toStr()) "
    //         } else {
    //             line += String(format: "%3d", worldWeights[y][x])
    //         }
    //         line += "|"
    //     }
    //     print(line)
    // }

    return "\(worldWeights[0][0])"
}

func buildPath(y: Int, x: Int, steps: [(y:Int,x:Int, dir: Direction)]) -> [(y:Int,x:Int, dir: Direction)] {
    if (x == maxX && y == maxY){
        return steps
    }

    let dir = getDirections(y:y, x:x).min(by: { $0.cost < $1.cost })!
    var steps = steps
    steps.append((y: dir.y, x: dir.x, dir: dir.dir))

    return buildPath(y:dir.y, x:dir.x, steps: steps)
}

func getDirections(y: Int, x: Int)-> [(y: Int,x: Int, dir: Direction, cost: Int)]{
    var dirs = [(Int,Int, Direction, Int)]()
    if (world.indices.contains(y+1)) {
        dirs.append((y: y+1,x: x,dir: Direction.S, cost: worldWeights[y+1][x]))
    }
    if (world.indices.contains(y-1)) {
        dirs.append((y: y-1,x: x,dir: Direction.N, cost: worldWeights[y-1][x]))
    }
    if (world[y].indices.contains(x+1)) {
        dirs.append((y: y,x: x+1,dir: Direction.E, cost: worldWeights[y][x+1]))
    }
    if (world[y].indices.contains(x-1)) {
        dirs.append((y: y,x: x-1,dir: Direction.W, cost: worldWeights[y][x-1]))
    }
    return dirs
}

func populateWeights(y: Int, x: Int,cost: Int, lastDirs: [Direction], visited: [(y: Int, x:Int)]) {
    var lastDirs = lastDirs
    if (y < 0 || y > maxY || x < 0 || x > maxX ) {
        return 
    }
    if (visited.contains {$0.y == y && $0.x == x}){
        return
    }
    let currCost = cost + world[y][x]
    if (worldWeights[y][x] < currCost){
        return
    }
    var visited = visited
    visited.append((y:y,x: x ))
    worldWeights[y][x] = currCost
    if (lastDirs.count > 3){
        lastDirs.removeFirst()
    }

    if (lastDirs.filter { $0 == .S }.count < 3 && lastDirs.last != .N) {
        var dirsToPass = lastDirs
        dirsToPass.append(.S)
        populateWeights(y: y + 1, x: x,cost: currCost, lastDirs: dirsToPass, visited: visited)
    }
    if (lastDirs.filter { $0 == .N }.count < 3 && lastDirs.last != .S) {
        var dirsToPass = lastDirs
        dirsToPass.append(.N)
        populateWeights(y: y - 1, x: x,cost: currCost, lastDirs: dirsToPass, visited: visited)
    }
    if (lastDirs.filter { $0 == .E }.count < 3 && lastDirs.last != .W) {
        var dirsToPass = lastDirs
        dirsToPass.append(.E)
        populateWeights(y: y, x: x + 1,cost: currCost, lastDirs: dirsToPass, visited: visited)
    }
    if (lastDirs.filter { $0 == .W }.count < 3 && lastDirs.last != .E) {
        var dirsToPass = lastDirs
        dirsToPass.append(.W)
        populateWeights(y: y, x: x - 1,cost: currCost, lastDirs: dirsToPass, visited: visited)
    }
}

// func getLoss(_ y: Int, _ x: Int, _ dir: Direction, _ mCnt: Int, _ loss: Int) -> Int {
//     if (!world.indices.contains(y) || !world[y].indices.contains(x) || cords.first { $0.y == y && $0.x == x } != nil) {
//         return Int.max
//     }
//     // End reached
//     if (y == world.count - 1 && x == world[y].count - 1 ) {
//         return loss
//     }
//     var cords = cords
//     cords.append((y,x))

//     var possibleLosses = [Int]()
//     var dirs : [Direction]  = [.N, .E, .S, .W]
//     dirs = dirs.filter { $0 != dir.opposite() }
//     if (mCnt >= 3 ){
//         dirs = dirs.filter { $0 != dir}
//     }

//     for nextDir in dirs {
//         let newCnt = nextDir == dir ? mCnt + 1 : 1
//         let newLoss = getLoss(world, y + nextY(nextDir), x + nextX(nextDir), nextDir, newCnt, loss + world[y][x], cords)
//         possibleLosses.append(newLoss)
//     }
//     return possibleLosses.min()!
// }


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