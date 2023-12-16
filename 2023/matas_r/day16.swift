import Foundation

enum ObjType {
    case RoundRock
    case SquareRock
}

enum Direction {
    case N
    case E
    case S
    case W
}

struct Obj {
    var c : Character
    var visited : [Direction]
    init(_ c: Character) {
        self.c = c
        self.visited = [Direction]()
    }
    mutating func visit(_ from: Direction) -> Bool {
        if (!self.visited.contains(from)){
            self.visited.append(from)
            return true
        } else {
            return false
        }
    }
    func isEnergized() -> Bool {
        visited.count > 0
    }
}

typealias World = [String:Obj]


func part1(_ input: String) -> String {
    let chars = input.split(whereSeparator: \.isNewline)
    .map { Array($0) }
    let maxY = chars.count - 1
    let maxX = chars[0].count - 1
    var world = [[Obj]]()
    for y in 0...maxY {
        var row = [Obj]()
        for x in 0...maxX {
            row.append(Obj(chars[y][x]))
        }
         world.append(row)
    }
    
    GoGoLaser(0,0, .E, &world)
    for y in 0...maxY {
        var line = ""
        for x in 0...maxX {
            line += world[y][x].isEnergized() ? "#" : "."
        }
        print(line)
    }

    var energy = 0
    for row in world {
        for obj in row {
            energy += obj.isEnergized() ? 1 : 0
        }
    }

    return "\(energy)"
}

func GoGoLaser(_ x: Int, _ y: Int, _ dir: Direction,  _ world: inout [[Obj]]) {
    if (!world.indices.contains(y) || !world[y].indices.contains(x)){
        return
    }
    let notEnd = world[y][x].visit(dir)
    if (!notEnd){
        return
    }

    switch world[y][x].c {
        case ".":
            GoGoLaser(x + nextX(dir), y + nextY(dir), dir, &world)
        case "|":
            if (dir == .N || dir == .S){
                GoGoLaser(x + nextX(dir), y + nextY(dir), dir, &world)
            }else {
                GoGoLaser(x + nextX(.N), y + nextY(.N), .N, &world)
                GoGoLaser(x + nextX(.S), y + nextY(.S), .S, &world)
            }
        case "-":
            if (dir == .E || dir == .W){
                GoGoLaser(x + nextX(dir), y + nextY(dir), dir, &world)
            }else {
                GoGoLaser(x + nextX(.E), y + nextY(.E), .E, &world)
                GoGoLaser(x + nextX(.W), y + nextY(.W), .W, &world)
            }
        case "/":
            let newDir: Direction = dir == .N ? .E :
                dir == .E ? .N :
                dir == .S ? .W :
                .S
            GoGoLaser(x + nextX(newDir), y + nextY(newDir), newDir, &world)
        case #"\"#:
            let newDir: Direction  = dir == .N ? .W :
                dir == .E ? .S :
                dir == .S ? .E :
                .N
            GoGoLaser(x + nextX(newDir), y + nextY(newDir), newDir, &world)
        default:
            break
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


func part2(_ input: String) -> String {
    let chars = input.split(whereSeparator: \.isNewline)
    .map { Array($0) }
    let maxY = chars.count - 1
    let maxX = chars[0].count - 1
    var world = [[Obj]]()
    for y in 0...maxY {
        var row = [Obj]()
        for x in 0...maxX {
            row.append(Obj(chars[y][x]))
        }
         world.append(row)
    }
    
    var energies = [Int]()
    for y in 0...maxY {
        var worldCopy = world
        GoGoLaser(0,y, .E, &worldCopy)
        var energy = 0
        for row in worldCopy {
            for obj in row {
                energy += obj.isEnergized() ? 1 : 0
            }
        }
        energies.append(energy)
    }
    for y in 0...maxY {
        var worldCopy = world
        GoGoLaser(maxX,y, .W, &worldCopy)
        var energy = 0
        for row in worldCopy {
            for obj in row {
                energy += obj.isEnergized() ? 1 : 0
            }
        }
        energies.append(energy)
    }
    for x in 0...maxX {
        var worldCopy = world
        GoGoLaser(x,0, .S, &worldCopy)
        var energy = 0
        for row in worldCopy {
            for obj in row {
                energy += obj.isEnergized() ? 1 : 0
            }
        }
        energies.append(energy)
    }
    for x in 0...maxX {
        var worldCopy = world
        GoGoLaser(x,maxY, .N, &worldCopy)
        var energy = 0
        for row in worldCopy {
            for obj in row {
                energy += obj.isEnergized() ? 1 : 0
            }
        }
        energies.append(energy)
    }

    return "\(energies.max())"
}

let input =
#"""
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
"""#