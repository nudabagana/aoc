import java.io.File
import kotlin.math.abs

val startTime = System.nanoTime()

val INPUT_FILE = File("./input.txt")

val mulPairs = readData(INPUT_FILE)
val mulSum = mulPairs.fold(0) {acc, value -> acc + value.first * value.second}

println(mulSum)
println("Execution time: ${(System.nanoTime() - startTime) / 1_000_000_000.0} seconds")

fun readData(file: File): List<Pair<Int,Int>> {
    val regex = Regex("""mul\((\d{1,3}),(\d{1,3})\)""")
    val content = file.readText()
    return regex.findAll(content).map { result ->
        Pair(result.groupValues[1].toInt(), result.groupValues[2].toInt())
    }.toList()
}