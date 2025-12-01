import java.io.File

val startTime = System.nanoTime()

val INPUT_FILE = File("./input.txt")

val commands = readData(INPUT_FILE)
var muls = mutableListOf<String>()
var enabled = true
commands.forEach { command ->
    if (enabled){
        if (command == "don't()") {
            enabled = false
        } else if (command != "do()"){
            muls.add(command)
        }
    } else if (command == "do()"){
        enabled = true
    }
}

val mulSum = muls.fold(0) { acc, value ->
    acc + value.substring(4, value.length - 1).split(",").fold(1) { acc, value -> acc * value.toInt()}
}

println(mulSum)
println("Execution time: ${(System.nanoTime() - startTime) / 1_000_000_000.0} seconds")

fun readData(file: File): List<String> {
    val regex = Regex("""(mul\(\d{1,3},\d{1,3}\)|do\(\)|don['’]t\(\))""")
    val content = file.readText()
    return regex.findAll(content).map { it.value }.toList()
}