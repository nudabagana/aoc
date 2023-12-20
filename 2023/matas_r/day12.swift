import Foundation


var count = 0
func part1(_ input: String) -> String {
    let lines =  input
    .split(whereSeparator: \.isNewline)
    .map{ (line: String($0.split(separator: " ")[0]), nums: String($0.split(separator: " ")[1]) )}

    for line in lines {
        let chars = Array(line.line)
        let nums = line.nums
        buildLine(chars, nums)
    }

    return "\(count)"
}

func part2(_ input: String) -> String {
    let ll =  input
    .split(whereSeparator: \.isNewline)
    .map{ (line: String($0.split(separator: " ")[0]), nums: String($0.split(separator: " ")[1]) )}
    .map{ (line: String(repeating: "\($0.line)?", count:5 ), nums: String(repeating: "\($0.nums),", count:5))}
    let lines = ll
    .map{ (line: String($0.line.dropLast()), nums: String($0.nums.dropLast()))}

    var countSum = 0
    for line in lines {
        let chars = Array(line.line)
        let nums = line.nums.split(separator: ",").map{ Int($0)!}
        countSum += countLine(chars,nums, 0)
    }

    return "\(countSum)"
}

var dict = [String: Int]()

func toStr(_ chars: Array<Character>.SubSequence, _ nums: [Int]) -> String{
    return "\(chars)\(nums.map { String($0) }.joined(separator: "-"))"
}

func countLine(_ chars: [Character], _ nums: [Int], _ idx: Int) -> Int {
    let strLeft = chars.suffix(max(0,chars.count - idx))
    if (strLeft.isEmpty){
        return nums.isEmpty ? 1 : 0
    }
    if (nums.isEmpty ){
        return strLeft.contains("#") ? 0 : 1
    }
    
    let key = toStr(strLeft,nums)
    if (dict.keys.contains(key)){
        return dict[key]!
    }

    var count = 0
    let char = chars[idx]
    if (".?".contains(char)){
        count += countLine(chars,nums,idx+1)
    }
    var nums = nums
    let num = nums.removeFirst()
    if ("#?".contains(char) && num <= strLeft.count && !strLeft.prefix(num).contains(".") && chars[s:idx+num] != "#" ){
        count += countLine(chars,nums, idx+num+1)
    }

    dict[key] = count
    return count
}

func buildLine(_ chars: [Character], _ nums: String) {
    let questionCount = chars.filter { $0 == "?"}.count
    if (questionCount <= 0){
        if (lineToValues(String(chars)) == nums){
            count += 1
        }
        return
    }
    let qId = chars.firstIndex(of: "?")!
    var charsDot = chars
    charsDot[qId] = "."
    buildLine(charsDot,nums)
    var charsSpring = chars
    charsSpring[qId] = "#"
    buildLine(charsSpring,nums)
}

func lineToValues(_ line: String) -> String{
    var values = ""
    var springs = 0
    for char in line {
        if (char == "." && springs > 0){
            values += "\(springs),"
            springs = 0
        }else if (char == "#"){
            springs += 1
        }
    }
    if (springs > 0){
        values += "\(springs),"
    }
    if (values.count > 0){
        values.removeLast()
    }
    return values
}

let input =
#"""
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""#

func makePears<T>(_ array: [T]) -> [(T, T)] {
    var pairs = [(T, T)]()
    for i in 0..<array.count {
        for j in i+1..<array.count {
            pairs.append((array[i], array[j]))
        }
    }
    return pairs
}

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