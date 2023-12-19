import Foundation

// var world  = [[String]]()

// func part1(_ input: String) -> String {
//     let lines = input.split(whereSeparator: \.isNewline)
//     .map { (dir:Direction(rawValue: String($0.split(separator:" ")[0]))! , len: Int($0.split(separator:" ")[1])!,
//      clr: $0.split(separator:" ")[2].dropFirst().dropLast()) }

//     var maxY = 0
//     var maxX = 0
//     var maxXs = [0]
//     var maxYs = [0]
//     for line in lines {
//         if (line.dir == .N){
//             maxY -= line.len
//         }else if (line.dir == .S){
//             maxY += line.len
//         }else if (line.dir == .E){
//             maxX += line.len
//         }else {
//             maxX -= line.len
//         }
//         maxXs.append(maxX)
//         maxYs.append(maxY)
//     }
//     maxY = maxYs.max()!
//     let minY = maxYs.min()!
//     maxX = maxXs.max()!
//     let minX = maxXs.min()!

//     world = Array(repeating: Array(repeating: ".", count: maxX - minX+1), count: maxY - minY+1)

//     var currX = 0 - minX
//     var currY = 0 - minY
//     for line in lines {
//         for _ in 0..<line.len {
//             currY += line.dir.vals().y
//             currX += line.dir.vals().x
//             world[currY][currX] = "#"
//         }
//     }

//     // printWorld()

//     var sum = 0
//     for y in 0..<world.count {
//         var inside = false
//         var insideWall = false
//         for x in 0..<world[y].count {
//             if (world[y][x] == "#" ){
//                 sum += 1
//                 if (inside == false &&
//                  lineHasWallNext(line: world[y], x: x) &&
//                   world[s:y-1]?[s:x+1] != "." && 
//                   world[s:y]?[s:x+1] == "."){
//                     inside = true
//                 } else if (!insideWall && inside) {
//                     inside = false
//                 }
//                 insideWall = true
//             } else {
//                 insideWall = false
//                 if (inside) {
//                     sum += 1
//                     world[y][x] = "#"
//                 }
//             }
//         }
//     }

//     printWorld()

//     return "\(sum)"
// }

// func printWorld(){
//         for y in 0..<world.count {
//         var str = ""
//         for x in 0..<world[y].count {
//             str += String(world[y][x])
//         }
//         print(str)
//     }
// }

func lineHasWallNext(line: [String], x: Int) -> Bool {
    for i in x+1..<line.count {
        if (line[i] == "#") {
            return true
        }
    }
    return false
}

var world = [[Bool]]()
func part2(_ input: String) -> String {
    let lines = input.split(whereSeparator: \.isNewline)
    .map{ $0.split(separator:" ")[2].dropFirst().dropLast().dropFirst() }
    .map { (dir: Direction.fromInt(Int(String($0.last!))!), len: Int($0.prefix(5), radix: 16)!) }

    var maxY = 0
    var maxX = 0
    var maxXs = [0]
    var maxYs = [0]
    for line in lines {
        if (line.dir == .N){
            maxY -= line.len
        }else if (line.dir == .S){
            maxY += line.len
        }else if (line.dir == .E){
            maxX += line.len
        }else {
            maxX -= line.len
        }
        maxXs.append(maxX)
        maxYs.append(maxY)
    }
    maxY = maxYs.max()!
    let minY = maxYs.min()!
    maxX = maxXs.max()!
    let minX = maxXs.min()!

    world = Array(repeating: Array(repeating: false, count: maxX - minX+1), count: maxY - minY+1)

    var currX = 0 - minX
    var currY = 0 - minY
    for line in lines {
        for _ in 0..<line.len {
            currY += line.dir.vals().y
            currX += line.dir.vals().x
            world[currY][currX] = true
        }
    }

    // // printWorld()

    var sum = 0
    // for y in 0..<world.count {
    //     var inside = false
    //     var insideWall = false
    //     for x in 0..<world[y].count {
    //         if (world[y][x] == "#" ){
    //             sum += 1
    //             if (inside == false &&
    //              lineHasWallNext(line: world[y], x: x) &&
    //               world[s:y-1]?[s:x+1] != "." && 
    //               world[s:y]?[s:x+1] == "."){
    //                 inside = true
    //             } else if (!insideWall && inside) {
    //                 inside = false
    //             }
    //             insideWall = true
    //         } else {
    //             insideWall = false
    //             if (inside) {
    //                 sum += 1
    //                 world[y][x] = "#"
    //             }
    //         }
    //     }
    // }

    // printWorld()

    return "\(sum)"
}

let input =
#"""
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
"""#

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
}

extension Array {
    subscript(s index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}