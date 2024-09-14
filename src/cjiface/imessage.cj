package cjweave.cjiface

// 消息
public interface IMessage {
    // 获取消息ID
    func getMsgId(): UInt32

    // 设置消息ID
    func setMsgId(msgId: UInt32): Unit

    // 获取消息体长度
    func getMsgLen(): UInt32

    // 设置消息长度
    func setMsgLen(len: UInt32): Unit

    // 获取消息体
    func getData(): Array<Byte>

    // 设置消息
    func setData(data: Array<Byte>): Unit

    // 设置消息
    func setData(data: String): Unit

    // toString
    func toString(): String
}

// 消息基类
public interface IMessageBase <: IMessage {}
