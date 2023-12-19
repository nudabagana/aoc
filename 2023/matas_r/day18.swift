import Foundation

var world  = [[String]]()

func part1(_ input: String) -> String {
    let lines = input.split(whereSeparator: \.isNewline)
    .map { (dir:Direction(rawValue: String($0.split(separator:" ")[0]))! , len: Int($0.split(separator:" ")[1])!) }
    var x = 1
    var y = 1
    var points = [(x:x, y:y)]
    for line in lines {
        x += line.dir.vals().x * line.len
        y += line.dir.vals().y * line.len
        points.append((x:x, y:y))
    }
    points.append((x:1, y:1))
    var sumX = 0
    var sumY = 0
    for i in 0..<points.count-1 {
        sumX += points[i].x * points[i+1].y
        sumY += points[i].y * points[i+1].x
    }

    let areaSum = abs(sumX-sumY) / 2
    let parts = lines.map {$0.len}.reduce(0,+) / 2 + 1
    let result = areaSum + parts

    return "\(result)"
}

func part2(_ input: String) -> String {
    let lines = input.split(whereSeparator: \.isNewline)
    .map{ $0.split(separator:" ")[2].dropFirst().dropLast().dropFirst() }
    .map { (dir: Direction.fromInt(Int(String($0.last!))!), len: Int($0.prefix(5), radix: 16)!) }

    var x = 1
    var y = 1
    var points = [(x:x, y:y)]
    for line in lines {
        x += line.dir.vals().x * line.len
        y += line.dir.vals().y * line.len
        points.append((x:x, y:y))
    }
    points.append((x:1, y:1))
    var sumX = 0
    var sumY = 0
    for i in 0..<points.count-1 {
        sumX += points[i].x * points[i+1].y
        sumY += points[i].y * points[i+1].x
    }

    let areaSum = abs(sumX-sumY) / 2
    let parts = lines.map {$0.len}.reduce(0,+) / 2 + 1
    let result = areaSum + parts

    return "\(result)"
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