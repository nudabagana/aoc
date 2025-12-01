import java.io.File
import kotlin.math.abs

val startTime = System.nanoTime()

val XMAS = "XMAS"
val SAMX = "SAMX"
val INPUT_FILE = File("./input.txt")

val lines = readData(INPUT_FILE)

val horizontalWords = countHorizontalXmas(lines)
val verticalXmas = countVerticalXmas(lines)
val diagonalXmas = countDiagonalXmas(lines)
// val reverseDiagonalXmas = reversDiagonalXmas(lines)
println(horizontalWords)
println(verticalXmas)
println(diagonalXmas)


println("Execution time: ${(System.nanoTime() - startTime) / 1_000_000_000.0} seconds")

fun readData(file: File): List<String> {
    val lines = mutableListOf<String>()
    file.forEachLine { line ->
        lines.add(line)
    }
    return lines
}

fun countHorizontalXmas(lines: List<String>): Int {
    var count = 0
    lines.forEach { line ->
        for (i in (0..line.length-4) ) {
            val word = line.substring(i, i + 4)
            if ( word == XMAS || word == SAMX){
                count++
            }
        }
    }
    return count
}

fun countVerticalXmas(lines: List<String>): Int {
    val transpoed = transposeCharacterList(lines)
    return countHorizontalXmas(transpoed)
}

fun transposeCharacterList(lines: List<String>): List<String> {
    val maxLength = lines.maxOfOrNull { it.length } ?: 0

    val transposed = (0 until maxLength).map { col ->
        lines.mapNotNull { row ->
            row.getOrNull(col) 
        }.joinToString("")
    }

    return transposed
}

fun countDiagonalXmas(lines: List<String>): Int {
    var count = 0

    for (x in 3..lines.size-1){
        var word = ""
        for (y in 0..x){
            if (word.length >= 4){
                word = word.dropLast(1)
            }
            word += lines[x-y][y]
            if (word == XMAS || word == SAMX){
                count++;
            }
            println(word)
        }
    }
    return count
}

