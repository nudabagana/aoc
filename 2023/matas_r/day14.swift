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
    let x, y : Int
    let type : ObjType
    init(_ x:Int, _ y: Int, _ type:ObjType){
        self.x = x
        self.y = y
        self.type = type
    }
    func canMove() -> Bool {
        type == .RoundRock
    }
}

typealias World = [String:Obj]

func part1(_ input: String) -> String {
    let chars = input.split(whereSeparator: \.isNewline)
    .map { Array($0) }
    let maxY = chars.count - 1
    let maxX = chars[0].count - 1
    var world = World()
    for y in 0...maxY {
        for x in 0...maxX {
            let char = chars[y][x]
            if (char != ".") {
                world["\(y)_\(x)"] = Obj(x,y,char == "#" ? .SquareRock : .RoundRock)
            }
        }
    }
    world = moveTillEnd(world, .N, maxX, maxY)

    let load = calcLoad(world, .N, maxY)
 
    return "\(load)"
}

func moveTillEnd(_ world: World, _ direction: Direction, _ maxX: Int, _ maxY: Int) -> World {
    var moved = true
    var world = world
    while (moved) {
        let res = move(world,direction, maxX, maxY)
        world = res.world
        moved = res.moved
    }
    return world
}

func move(_ world: World, _ direction: Direction, _ maxX: Int, _ maxY: Int) -> (world: World, moved: Bool) {
    var moved = false
    var newWorld = World()
    switch direction {
        case .N:
            let items = world.values.sorted(by: { $0.y < $1.y })
            for item in items {
                let x = item.x
                let y = item.y
                if (item.canMove() && item.y > 0 && newWorld["\(y-1)_\(x)"] == nil){
                    moved = true
                    newWorld["\(y-1)_\(x)"] = Obj(x,y-1,item.type)
                } else {
                    newWorld["\(y)_\(x)"] = item
                }
            }
        case .S:
            let items = world.values.sorted(by: { $0.y > $1.y })
            for item in items {
                let x = item.x
                let y = item.y
                if (item.canMove() && item.y < maxY && newWorld["\(y+1)_\(x)"] == nil){
                    moved = true
                    newWorld["\(y+1)_\(x)"] = Obj(x,y+1,item.type)
                } else {
                    newWorld["\(y)_\(x)"] = item
                }
            }
        case .W:
            let items = world.values.sorted(by: { $0.x < $1.x })
            for item in items {
                let x = item.x
                let y = item.y
                if (item.canMove() && item.x > 0 && newWorld["\(y)_\(x-1)"] == nil){
                    moved = true
                    newWorld["\(y)_\(x-1)"] = Obj(x-1,y,item.type)
                } else {
                    newWorld["\(y)_\(x)"] = item
                }
            }
        case .E:
            let items = world.values.sorted(by: { $0.x > $1.x })
            for item in items {
                let x = item.x
                let y = item.y
                if (item.canMove() && item.x < maxX && newWorld["\(y)_\(x+1)"] == nil){
                    moved = true
                    newWorld["\(y)_\(x+1)"] = Obj(x+1,y,item.type)
                } else {
                    newWorld["\(y)_\(x)"] = item
                }
            }
    }

    return (world: newWorld, moved: moved)
}

func calcLoad(_ world: World, _ direction: Direction, _ max: Int) -> Int {
    var load = 0
    let items = world.values.filter { $0.type == .RoundRock }
    switch direction {
        case .N:
            load = items.map { max - $0.y+1 }.reduce(0,+)
        case .E, .S, .W:
            break
    }

    return load
}

func part2(_ input: String) -> String {
    let chars = input.split(whereSeparator: \.isNewline)
    .map { Array($0) }
    let maxY = chars.count - 1
    let maxX = chars[0].count - 1
    var world = World()
    for y in 0...maxY {
        for x in 0...maxX {
            let char = chars[y][x]
            if (char != ".") {
                world["\(y)_\(x)"] = Obj(x,y,char == "#" ? .SquareRock : .RoundRock)
            }
        }
    }
    var worldBank = [String: (World,Int)]()
    var i = 1
    var skipped = false
    while ( i <= 1000000000 ) {
        if (!skipped) {
        let worldKey = world.keys.sorted { $0 < $1 } .reduce("",+)
            if (worldBank[worldKey] != nil){
                let iterationsBefore = i-worldBank[worldKey]!.1
                print("World loop found \(iterationsBefore) iterations before")
                i = 1000000000 - ((1000000000 - i) % iterationsBefore)
                skipped = true
            } else {
                worldBank[worldKey] = (world,i)
            }
        }
        world = moveTillEnd(world, .N, maxX, maxY)
        world = moveTillEnd(world, .W, maxX, maxY)
        world = moveTillEnd(world, .S, maxX, maxY)
        world = moveTillEnd(world, .E, maxX, maxY)
        i += 1
    }


    let load = calcLoad(world, .N, maxY)
 
    return "\(load)"
}

let input =
"""
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
"""