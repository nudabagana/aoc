import Foundation

func part1(_ input: String) -> String {
    let parts = input.components(separatedBy: "\n\n")
    let moves = Array(parts[0])
    let nodes = parts[1].split(whereSeparator: \.isNewline)
    .map { $0.replacingOccurrences(of: " ", with: "") }
    .map { (id: $0.split(separator: "=")[0], other: $0.split(separator: "=")[1].dropFirst().dropLast())}
    .map { (id: $0.id, left: $0.other.split(separator: ",")[0], right: $0.other.split(separator: ",")[1])}
    var nodeDict = [String: (id: String, left: String, right: String)]()
    for node in nodes {
        nodeDict[String(node.id)] = (id: String(node.id), left: String(node.left), right: String(node.right))
    }
    var movCount = 0
    var currNode = nodeDict["AAA"]!
    while (currNode.id != "ZZZ"){
        let move = moves[movCount % moves.count]
        currNode = move == "L" ? nodeDict[currNode.left]! : nodeDict[currNode.right]!
        movCount += 1
    }

    return "\(movCount)"
}


func part2(_ input: String) -> String {
    let parts = input.components(separatedBy: "\n\n")
    let moves = Array(parts[0])
    let nodes = parts[1].split(whereSeparator: \.isNewline)
    .map { $0.replacingOccurrences(of: " ", with: "") }
    .map { (id: $0.split(separator: "=")[0], other: $0.split(separator: "=")[1].dropFirst().dropLast())}
    .map { (id: $0.id, left: $0.other.split(separator: ",")[0], right: $0.other.split(separator: ",")[1])}
    var nodeDict = [String: (id: String, left: String, right: String, notEnd: Bool)]()
    for node in nodes {
        nodeDict[String(node.id)] = (id: String(node.id), left: String(node.left), right: String(node.right), notEnd: node.id.last! != "Z")
    }

    var movCount = 0
    var currNodes = nodeDict.values.filter { $0.id.last! == "A" }
    var finishNodes = [Int: [Int]]()
    finishNodes[0] = [Int]()
    while ( finishNodes.values.first { $0.count < 2} != nil ) {
        let move = moves[movCount % moves.count]
        movCount += 1
        var i = 0
        while (i < currNodes.count) {
            currNodes[i] = move == "L" ? nodeDict[currNodes[i].left]! : nodeDict[currNodes[i].right]!
            if (!currNodes[i].notEnd){
                finishNodes[i] = finishNodes[i] ?? [Int]()
                finishNodes[i]!.append(movCount)
            }
            i += 1
        }
    }

    let finishNodesArr = Array(finishNodes.values).map { arr in 
        var arr = arr
        arr[1] = arr[1] - arr[0]
        return arr 
    }
    let minMovValue = finishNodesArr.map { $0[1] }.min()!
    movCount = finishNodesArr.first { $0[1] == minMovValue }![0]

    var found = false
    var i = 0
    while (!found){
        found = true
        i = 0
        while (i < 6) {
            let node = finishNodesArr[i]
            if ((movCount - node[0]) % node[1] != 0){
                found = false
            }
            i += 1
        }
        movCount += minMovValue
    }

    return "\(movCount)"
}

let input =
"""
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
"""