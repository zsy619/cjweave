package cjweave

import std.sync.*
import std.time.*
import std.net.*

extend String {
    public func map(mapper: (String) -> String): String {
        mapper(this)
    }
}

public class Foo {
    public static var param1 = 20
    public var param2 = 10
}

@OverflowThrowing
main(): Int64 {
    let fut: Future<Unit> = spawn {
        =>
        println("New thread before sleeping")
        sleep(100 * Duration.millisecond) // sleep for 100ms.
        println("New thread after sleeping")
    }
    println("Main thread")

    var a: String = "嘿"
    a = a.map {s => s + "，仓颉"}
    println(a)

    let c: (Name: String, Age: Int) = ("张三", 18)
    println(c[0])
    println(bar(c[1]))

    fut.get()

    return 0
}

func bar(a: Int): ?Int {
    return a
}
