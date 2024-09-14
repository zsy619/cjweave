package cjweave.cjnet

import std.net.*
import cjweave.cjiface.*
import cjweave.xtool.*
import cjweave.cjutil.*
import encoding.json.stream.*
import serialization.serialization.*
import cjweave.cjiface.IServer
import encoding.json.*

// 消息类
public class Message <: IMessage & Serializable<Message> {
    protected var msgId: UInt32 = 0
    protected var msgLen: UInt32 = 0
    protected var data: Array<Byte> = []

    public init() {
        msgId = 0
        msgLen = 0
        data = []
    }

    public func serialize(): DataModel {
        return DataModelStruct().add(field<UInt32>("msgId", msgId)).add(field<UInt32>("msgLen", msgLen)).add(
            field<Array<Byte>>("data", data))
    }

    public static func deserialize(dm: DataModel): Message {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = Message()
        result.msgId = UInt32.deserialize(dms.get("msgId"))
        result.msgLen = UInt32.deserialize(dms.get("msgLen"))
        result.data = Array<Byte>.deserialize(dms.get("data"))
        return result
    }

    // 获取消息ID
    public func getMsgId(): UInt32 {
        msgId
    }

    // 设置消息ID
    public func setMsgId(msgId: UInt32): Unit {
        this.msgId = msgId
    }

    // 获取消息体长度
    public func getMsgLen(): UInt32 {
        msgLen
    }

    // 设置消息长度
    public func setMsgLen(len: UInt32): Unit {
        this.msgLen = len
    }

    // 获取消息体
    public func getData(): Array<Byte> {
        data
    }

    // 设置消息
    public func setData(data: Array<Byte>): Unit {
        this.data = data
        this.msgLen = UInt32(data.size)
    }

    // 设置消息
    public func setData(data: String): Unit {
        this.data = data.toArray()
        this.msgLen = UInt32(this.data.size)
    }

    // toString
    public func toString(): String {
        return "Message [MsgID=${this.msgId}, MsgLen=${this.msgLen}]"
    }
}

public func newMessage(): IMessage {
    return Message()
}

public func newMessage(msgId: UInt32, data: Array<Byte>): IMessage {
    var msg = Message()
    msg.setMsgId(msgId)
    msg.setData(data)
    return msg
}

public func newMessage(msgId: UInt32, data: String): IMessage {
    var msg = Message()
    msg.setMsgId(msgId)
    msg.setData(data.toArray())
    return msg
}

public func newMessagePack(msgId: UInt32, data: Array<Byte>): Array<Byte> {
	var pack = newDataPack()
	var msg = Message()
    msg.setMsgId(msgId)
    msg.setData(data)
    return pack.pack(msg)
}

public func newMessagePack(msgId: UInt32, data: String): Array<Byte> {
	var ds = data.toArray()
	newMessagePack(msgId, ds)
}