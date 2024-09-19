package cjweave.xtool

import std.time.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.concurrent.*
import std.collection.*

@Test
class PcpChannelTests {
    @TestCase
    public func testPcpChannel() {
        let chn = newPcpChannel<Int64>(20)
        spawn {
            for (i in 1..1000) {
                chn.send(i)
            }
        }
        spawn {
            while (true) {
                println(chn.recv())
            }
        }

        while (true) {
            sleep(Duration.millisecond * 500)
        }
    }

    @TestCase
    public func testBlockingQueue() {
        let q = BlockingQueue<Bool>(3)
        q.enqueue(true)
        q.enqueue(true)
        q.enqueue(true)
        for (i in 1..4) {
            spawn {
                println("${i} ${q.dequeue()}")
            }
        }
        while (true) {
            sleep(Duration.millisecond * 100)
            break
        }
    }
}
