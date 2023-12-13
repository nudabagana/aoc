import Foundation

func part2(_ input: String) -> String {
    let lines = input
    .split(whereSeparator: \.isNewline)

    var startNewMap = false
    var dictArr = [(from: Int,to: Int,diff: Int)]()
    var srcNums = [(from: Int, to: Int)]()
    for line in lines {
        if (line.starts(with: "seeds")){
            let numsToFill = line.split(separator: ":")[1].split(separator: " ").map { Int($0)! }
            var i = 0
            while( i <= numsToFill.count-2) {
                srcNums.append((from: numsToFill[i], to: numsToFill[i] + numsToFill[i+1]))
                i += 2
            }
        } else if (line.contains("map")) {
            startNewMap = true
        } else {
            if (startNewMap){
                startNewMap = false
                srcNums = parseMap(srcNums, dictArr)
                dictArr = [(from: Int,to: Int,diff: Int)]()
            }
            let dictValues = line.split(separator: " ")
            let dest = Int(dictValues[0])!
            let src = Int(dictValues[1])!
            let range = Int(dictValues[2])!
            dictArr.append((from:src, to: src+range, diff: dest-src))
        }
    }
    srcNums = parseMap(srcNums, dictArr)

    return "\(srcNums.map { $0.from }.min()!)"
}

func parseMap(_ srcNums: [(from: Int, to: Int)], _ dictArr: [(from: Int,to: Int,diff: Int)]) -> [(from: Int, to: Int)] {
    var newNums = [(from: Int, to: Int)]()
    srcNums.forEach { src in 
        var deductFromSrc = [(from:Int, to:Int)]()
        for dest in dictArr {
            if (src.to < dest.from || src.from > dest.to){
                // no interaction
            }else if (src.from >= dest.from && src.to <= dest.to){
                // src inside dest
                newNums.append((from: src.from + dest.diff, to: src.to + dest.diff))
                deductFromSrc.append((from: src.from, to: src.to))
            } else if (src.from <= dest.from && src.to >= dest.to) {
                // dest inside src
                newNums.append((from: dest.from + dest.diff, to: dest.to + dest.diff))
                deductFromSrc.append((from: dest.from, to: dest.to))
            } else if (src.from <= dest.from && src.to <= dest.to) {
                // src left of dest
                newNums.append((from: dest.from + dest.diff, to: src.to + dest.diff))
                deductFromSrc.append((from: dest.from, to: src.to))
            } else if ( src.from >= dest.from && src.to >= dest.to){
                // src right of dest
                newNums.append((from: src.from + dest.diff, to: dest.to + dest.diff))
                deductFromSrc.append((from: src.from, to: dest.to))
            }
        }
        let leftovers = getLeftovers(src, deductFromSrc)
        newNums.append(contentsOf: leftovers)
    }

    return dictArr.count <= 0 ? srcNums : newNums 
}

func getLeftovers(_ src: (from: Int, to: Int), _ deductFromSrc: [(from: Int, to: Int)]) -> [(from: Int, to: Int)] {
    var result = [(from: Int, to: Int)]()
    var start = src.from

    for interval in deductFromSrc {
        if start < interval.from {
            result.append((from: start, to: interval.from - 1))
        }
        if interval.to < src.to {
            start = interval.to + 1
        } else {
            start = src.to
        }
    }

    if start < src.to {
        result.append((from: start, to: src.to))
    }

    return result
}

let input =
"""
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"""