import Foundation

func part1(_ input: String) -> String {
    let grids = input.components(separatedBy: "\n\n").map {
        $0.split(whereSeparator: \.isNewline)
        .map {str in
        Array(str)}
    }

    var sum = 0
    for grid in grids {
        let rowCount = grid.count
        let colCount = grid[0].count
        let res = checkAndReturnNum(rowCount,colCount, grid, -1)

        if (res > 0){
            sum += res * 100
        } else {
            sum += checkAndReturnNum(colCount,rowCount, transpose(grid), -1)
        }
    }
    
    return "\(sum)"
}

func part2(_ input: String) -> String {
    let grids = input.components(separatedBy: "\n\n").map {
        $0.split(whereSeparator: \.isNewline)
        .map {str in
        Array(str)}
    }

    var sum = 0
    for grid in grids {
        let (ignoreH, ignoreV) = processGrid(grid, -1, -1)
        var found = false
        for i in 0..<grid.count {
            if (!found){
                for i2 in 0..<grid[i].count{
                    if (!found) {
                        var cGrid = grid
                        cGrid[i][i2] = cGrid[i][i2] == "." ? "#" : "."
                        
                        let res = processGrid(cGrid, ignoreH, ignoreV)
                        if (res.0 > 0 || res.1 > 0){
                            found = true
                            sum += res.0 * 100 + res.1
                        }
                        cGrid[i][i2] = cGrid[i][i2] == "." ? "#" : "."
                    }
                }
            }
        }
    }
    
    return "\(sum)"
}

func sumSide(from: Int, _ sideSize: Int, _ colCount: Int, _ grid: [Array<Substring.Element>], _ left: Bool) -> String {
    let by = left ? -1 : 1
    var side = ""
    for currRowId in stride(from: from, through: from + (sideSize * by), by: by) {
        for colId in 0..<colCount {
            side += String(grid[currRowId][colId])
        }
    }

    return side
}

func checkAndReturnNum(_ rowCount: Int, _ colCount: Int, _ grid: [Array<Substring.Element>], _ ignoreId: Int) -> Int {
        for rowId in 0...rowCount-2 {
            let sideSize = min(rowId, rowCount-rowId-2)
            let leftSide = sumSide(from: rowId, sideSize, colCount, grid, true)
            let rightSide = sumSide(from: rowId+1, sideSize, colCount, grid, false)
            
            if (leftSide == rightSide && rowId+1 != ignoreId){
                return rowId+1
            }
    }
    return 0
}

func transpose(_ input: [[Character]]) -> [[Character]] {
    let rowCount = input.count
    let colCount = input[0].count

    var output: [[Character]] = Array(repeating: Array(repeating: " ", count: rowCount), count: colCount)
    
    for i in 0..<rowCount {
        for j in 0..<colCount {
            output[j][i] = input[i][j]
        }
    }
    
    return output
}

func processGrid(_ grid: [[Character]], _ ignoreH: Int, _ ignoreV: Int) -> (Int, Int) {
    let rowCount = grid.count
    let colCount = grid[0].count
    let resH = checkAndReturnNum(rowCount,colCount, grid, ignoreH)

    if (resH > 0){
        return (resH, 0)
    } 
    let resV = checkAndReturnNum(colCount,rowCount, transpose(grid), ignoreV)
    return (0, resV)
}



let input =
"""
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
"""