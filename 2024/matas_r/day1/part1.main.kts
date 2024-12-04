import java.io.File
import kotlin.math.abs

val INPUT_FILE = File("./input.txt")

val (list1, list2) = readLists(INPUT_FILE)

val list1Ordered = list1.sorted()
val list2Ordered = list2.sorted()

var diffSum = 0
for (i in list1Ordered.indices) {
    diffSum += abs(list1Ordered[i] - list2Ordered[i])
}

println(diffSum)

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

