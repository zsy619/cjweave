package cjweave.xtool

public interface UIntXToBytes {
    func toBytes(): Array<Byte>
}

extend UInt16 <: UIntXToBytes {
    public func toBytes(): Array<Byte> {
        Array<Byte>(2) {
            i => UInt8((this >> (16 - 8 * (i + 1))) & 0xFF)
        }
    }
}

extend UInt32 <: UIntXToBytes {
    public func toBytes(): Array<Byte> {
        Array<Byte>(4) {
            i => UInt8((this >> (32 - 8 * (i + 1))) & 0xFF)
        }
    }
}
