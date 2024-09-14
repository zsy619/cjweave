package cjweave.xtool

import std.net.*
import std.time.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*
import cjweave.cjutil.*

@Test
class uintTests {
    @TestCase
    func testUInt16() {
        var ut16: UInt16 = 1256
        println(ut16.toBytes())
    }

    @TestCase
    func testUInt32() {
        var ut32: UInt32 = 25
        println(ut32.toBytes())
    }
}
