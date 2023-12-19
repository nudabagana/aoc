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

func part1(_ input: String) -> String {
    var chars = input.split(whereSeparator: \.isNewline)
    .map { Array($0) }
    .map { $0.map { c in Int(String(c))! } }
    .map { $0.map { n in (n,Int.max)}}
    
    let (minLoss, cords) = getLoss(&chars, 0,0, .E, 0, 0, [(0,0)])

    for y in 0..<chars.count {
        var line = ""
        for x in 0..<chars[y].count {
            // if (cords.contains { $0.0 == y && $0.1 == x}) {
            //     line += "#"
            // }else {
                line += String(format: "%3d" ,chars[y][x].1) + "|"
                // line += "."
            // }
        }
        print(line)
    }

    return "\(minLoss)"
}

var test = false
var testNr = 0

func getLoss(_ world: inout [[(Int, Int)]], _ y: Int, _ x: Int, _ dir: Direction, _ mCnt: Int, _ loss: Int, _ cords: [(Int,Int)]) -> (Int,[(Int,Int)]) {
    // if (!world.indices.contains(y) || !world[y].indices.contains(x) || world[y][x].1 < loss) {
    testNr += 1
    if (!world.indices.contains(y) || !world[y].indices.contains(x) || cords.first { $0.0 == y && $0.1 == x } != nil) {
        return (Int.max,cords)
    }
    if (y == world.count - 1 && x == world[y].count - 1 ) {
        return (loss,cords)
    }
    world[y][x].1 = loss
    var cords = cords
    cords.append((y,x))


    // if (x == 2 && y == 5){
    //     print("WOOHOO")
    //     test = true
    // }
    // if (x == 5 && y == 2){
    //     print("WOOHOO")
    // }
    // if (test && x == 2){
    //     print("A")
    // }
    if (testNr % 100000 == 0){
        print("B")
    }
    var possibleLosses = [(Int,[(Int,Int)])]()
    var dirs : [Direction]  = [.N, .E, .S, .W]
    dirs = dirs.filter { $0 != dir.opposite() }
    if (mCnt >= 3 ){
        dirs = dirs.filter { $0 != dir}
    }

    for nextDir in dirs {
        let newCnt = nextDir == dir ? mCnt + 1 : 1
        let newLoss = getLoss(&world, y + nextY(nextDir), x + nextX(nextDir), nextDir, newCnt, loss + world[y][x].0, cords)
        possibleLosses.append(newLoss)
    }
    let min = possibleLosses.map { $0.0 }.min()!
    return (min, possibleLosses.first { $0.0 == min}!.1)
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