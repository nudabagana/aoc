import Foundation

func part1(_ input: String) -> String {
    let strings = input.split(separator: ",")
    .map { calcStringValue(String($0)) }
    .reduce(0,+)

    return "\(strings)"
}

func calcStringValue(_ str: String)-> Int {
    var sum = 0
    for char in str {
        sum += Int(exactly: char.asciiValue!)!
        sum *= 17
        sum %= 256
    }
    return sum
}

func part2(_ input: String) -> String {
    let items = input.split(separator: ",")
    .map { $0.contains("=") ?
         (label: String($0.split(separator: "=")[0]), op: String($0.split(separator: "=")[1])) :
         (label: String($0.dropLast()), op: "-")
    }.map { (box: calcStringValue($0.label), label: $0.label, op: $0.op) }

    var boxes = Array(repeating: [(label: String, lens: String)](), count: 256)
    for item in items {
        if (item.op == "-"){
            boxes[item.box] = boxes[item.box].filter { $0.label != item.label } 
        } else {
            let labelIdx = boxes[item.box].firstIndex(where: {$0.label == item.label} )
            if (labelIdx != nil){
                boxes[item.box][labelIdx!].lens = item.op
            } else {
                boxes[item.box].append((label: item.label, lens: item.op))
            }
        }
    }

    var sum = 0
    for i in 0..<boxes.count {
        let box = boxes[i]
        for i2 in 0..<box.count {
            let valToAdd = (i + 1) * (i2 + 1) * Int(box[i2].lens)!
            sum += valToAdd
        }
    }

    return "\(sum)"
}

let input =
"""
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
"""