package cjweave.xphp

import std.collection.*
import cjweave.xtype.*

// public func newSlice<T>(start: T, end: T, step: T): ArrayList<T> where T <: Number<T> {
//     if (step <= 0 || end < start) {
//         return ArrayList<T>([])
//     }
//     var st = start
//     let aryList = ArrayList<T>(1 + Int64((end - start) / step))
//     var index = 0i64
//     while (st <= end) {
//         aryList.set(index, st)
//         st += step
//         index++
//     }
//     return aryList
// }

public func newSliceInt32(start: Int32, end: Int32, step: Int32): Array<Int32> {
    if (step <= 0 || end < start) {
        return Array<Int32>()
    }
    var st = start
    let s = Array<Int32>(1 + Int64((end - start) / step), repeat: 0)
    var index = 0i64
    while (st <= end) {
        s[index] = st
        st += step
        index++
    }
    return s
}

public func newSliceInt16(start: Int16, end: Int16, step: Int16): Array<Int16> {
    if (step <= 0 || end < start) {
        return Array<Int16>()
    }
    var st = start
    let s = Array<Int16>(1 + Int64((end - start) / step), repeat: 0)
    var index = 0i64
    while (st <= end) {
        s[index] = st
        st += step
        index++
    }
    return s
}
