package cjweave.cjnet

import std.net.*
import cjweave.cjiface.*
import cjweave.xtool.*
import cjweave.cjutil.*
import std.collection.*
import std.binary.*
import std.unittest.*
import std.unittest.testmacro.*
import std.convert.*

// 封包、拆包，直接面向TCP数据流
public class DataPack <: IDataPack<IMessage> {
    // 获取包头长度
    public func getHeadLen(): UInt32 {
        return 8 // 消息ID(4字节) + 消息长度(4字节)
    }

    // 封包
    public func pack(msg: IMessage): Array<Byte> {
        // 字节流
        var dataBuffer = ArrayList<Byte>()

        // 将dataLen写入dataBuffer
        var msgLen = msg.getMsgLen()
        var msgLenArray = Array<Byte>(4, repeat: 0)
        msgLen.writeLittleEndian(msgLenArray)
        dataBuffer.appendAll(msgLenArray)

        // 将messageID写入dataBuffer
        var msgIdArray = Array<Byte>(4, repeat: 0)
        msg.getMsgId().writeLittleEndian(msgIdArray)
        dataBuffer.appendAll(msgIdArray)

        // 将data数据写入dataBuffer
        // for (i in 0..Int64(msgLen)) {
        //     var ary = Array<Byte>(1, repeat: 0)
        //     msg.getData()[i].writeLittleEndian(ary)
        //     dataBuffer.appendAll(ary)
        // }
        // var dataArray = Array<Byte>()
        // msg.getData().writeLittleEndian(dataArray)
        // dataBuffer.appendAll(dataArray)
        dataBuffer.appendAll(msg.getData())

        return dataBuffer.toArray()
    }

    // 拆包(将包的head信息读取出来)，之后根据head信息里的dataLen，再读取data数据
    public func unPack(data: Array<Byte>): IMessage {
        if (data.size < 8) {
            throw Exception("数据包长度小于头信息要求长度")
        }
        // 读取dataLen
        var msgLenArray = data[0..4]
		println("unPack msgLenArray: ${msgLenArray}")
        let msgLen = UInt32.readLittleEndian(msgLenArray)
        // 判断dataLen是否超过最大包允许长度
        if (GlobalConfig.MaxPackageSize > 0 && Int64(msgLen) > GlobalConfig.MaxPackageSize && msgLen != 0) {
            throw Exception("包长度${msgLen}超过最大值${GlobalConfig.MaxPackageSize}")
        }
        var msg = Message()
        msg.setMsgLen(msgLen)
        var dataBuffer = ArrayList<Byte>()
        // 读取messageID
        var msgIdArray = data[4..8]
        let msgId = UInt32.readLittleEndian(msgIdArray)
        msg.setMsgId(msgId)
        return msg
    }

	 // toString
    public func toString(): String {
        return "DataPack [HeadLen=${this.getHeadLen()}]"
    }
}

public func newDataPack(): IDataPack<IMessage> {
    return DataPack()
}
