import Foundation

func part1(_ input: String) -> String {
    return "\(0)"
}

func part2(_ input: String) -> String {
    return "\(0)"
}

let input =
#"""
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
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