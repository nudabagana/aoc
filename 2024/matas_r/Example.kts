@file:Repository("https://repo.maven.apache.org/maven2/")
@file:DependsOn("com.squareup.moshi:moshi:1.15.0")

import com.squareup.moshi.Moshi

val moshi = Moshi.Builder().build()
println("Moshi is ready: $moshi")
