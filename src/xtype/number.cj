package cjweave.xtype

public interface Number<T> {
    operator func +(b: T): T
    operator func >(b: T): Bool
    operator func >=(b: T): Bool
    operator func <(b: T): Bool
    operator func <=(b: T): Bool
    operator func -(b: T): T
    operator func /(b: T): T
}

extend Int64 <: Number<Int64> {}

extend Int32 <: Number<Int32> {}

extend Int16 <: Number<Int16> {}

extend Int8 <: Number<Int8> {}

extend Float64 <: Number<Float64> {}

extend Float32 <: Number<Float32> {}

extend Float16 <: Number<Float16> {}

extend UInt8 <: Number<UInt8> {}

extend UInt16 <: Number<UInt16> {}

extend UInt32 <: Number<UInt32> {}

extend UInt64 <: Number<UInt64> {}
