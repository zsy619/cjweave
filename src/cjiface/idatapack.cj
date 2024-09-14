package cjweave.cjiface

// 封包、拆包接口
public interface IDataPack<T> where T <: IMessage {
    // 获取包头长度
    func getHeadLen(): UInt32

    // 封包
    func pack(message: T): Array<Byte>

    // 拆包
    func unPack(data: Array<Byte>): T

    // toString
    func toString(): String
}

// 基础封包、拆包接口基类
public interface IDataPackBase <: IDataPack<IMessage> {}
