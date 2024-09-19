package cjweave.xtool

import std.net.*
import std.time.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.concurrent.*
import std.collection.*

@Test
class RawSocketTests {
    @TestCase
    func testRawSocket() {
        try {
            let socket = RawSocket(SocketDomain.IPV4, SocketType.RAW, ProtocolType.IPV4)
            socket.bind(RawAddress("0.0.0.0:9090".toArray()))
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }
}
