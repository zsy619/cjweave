package cjweave.xtool

import std.binary.*
import std.collection.*
import std.convert.*

extend<Byte> Array<Byte> {
    // public func writeLittleEndian(buffer: Array<Byte>): Int64 {
    //     var i = 0
    //     var dataBuffer = ArrayList<Byte>()
    // 	var sz = this.size
    //     while (i < sz) {
    //         var ary = Array<Byte>(1, repeat: 0)
    //         this.get(i)?.writeLittleEndian(ary)
    //         dataBuffer.appendAll(ary)
    //         i += 1
    //     }
    //     buffer = dataBuffer.toArray()
    //     buffer.size()
    // }

    // public func writeBigEndian(buffer: Array<Byte>): Int64 {
    //     var i = 0
    //     var dataBuffer = ArrayList<Byte>()
    //     while (i < this.size) {
    //         var ary = Array<Byte>(1, repeat: 0)
    //         this[i].writeBigEndian(ary)
    //         dataBuffer.appendAll(ary)
    //         i += 1
    //     }
    //     buffer = dataBuffer.toArray()
    // 	buffer.size()
    // }
}

extend UInt32 {
    //小端序
    func toBytesByLittle(u32: UInt32): Array<Byte> {
        Array<Byte>(4, {i => UInt8(u32 >> (i * 8) & 0xff)})
    }

    //大端序
    func toBytesByBig(u32: UInt32): Array<Byte> {
        Array<Byte>(4, {i => UInt8(u32 >> (24 - i * 8) & 0xff)})
    }
}
