import java.io.File
import kotlin.math.abs

val startTime = System.nanoTime()

val INPUT_FILE = File("./input.txt")

val (list1, list2) = readLists(INPUT_FILE)

val frequencyMap = list2.groupingBy { it }.eachCount()

var similarityScore = 0
for (i in list1.indices) {
    val num = list1[i]
    val timesInList2 = frequencyMap[num] ?: 0
    similarityScore += num * timesInList2
}

println(similarityScore)
println("Execution time: ${(System.nanoTime() - startTime) / 1_000_000_000.0} seconds")

fun readLists(file: File): Pair<List<Int>,List<Int>> {
    val list1 = mutableListOf<Int>()
    val list2 = mutableListOf<Int>()
    file.forEachLine { line ->
        val (value1, value2) = line.split("\\s+".toRegex())
        list1.add(value1.toInt())
        list2.add(value2.toInt())
    }
    return Pair(list1, list2)
}

