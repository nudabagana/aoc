import java.io.File
import kotlin.math.abs

val startTime = System.nanoTime()

val INPUT_FILE = File("./input.txt")

val reports = readData(INPUT_FILE)

println(reports.count { checkReportSafetyWithDampening(it) })
println("Execution time: ${(System.nanoTime() - startTime) / 1_000_000_000.0} seconds")

fun readData(file: File): List<List<Int>> {
    val reports = mutableListOf<List<Int>>()
    file.forEachLine { line ->
        val numbers = line.split("\\s+".toRegex()).map { it.toInt() }
        reports.add(numbers)
    }
    return reports
}

val checkReportSafetyWithDampening = fun(report: List<Int>): Boolean {
    val isSafe = isReportSafe(report)
    if (isSafe){
        return true
    }
    for (i in report.indices){
        val dampReport = report.filterIndexed { index, _ -> index != i }
        val isSafe = isReportSafe(dampReport)
        if (isSafe){
            return true
        }
    }
    return false
}

fun isReportSafe(report: List<Int>): Boolean {
    if (report.size <= 1){
        return true
    }

    var prevNum = report[0]
    val isIncreasing = prevNum < report[1]
    report.drop(1).forEach { num ->
        if (isIncreasing){
            if (prevNum < num - 3 || prevNum >= num){
                return false
            }
        } else {
            if (prevNum > num + 3 || prevNum <= num){
                return false
            }
        }
        prevNum = num
    }
    return true
}

