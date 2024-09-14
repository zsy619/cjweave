package cjweave.cjnet

import std.net.*
import cjweave.cjiface.*
import cjweave.xtool.*
import cjweave.cjutil.*

public class Reqeust <: IRequestBase {
    private var _connection: ?IConnection = None
    public mut prop Connection: ?IConnection {
        get() {
            _connection
        }
        set(value) {
            _connection = value
        }
    }

    private var _clientSocket: ?TcpSocket = None
    public mut prop ClientSocket: ?TcpSocket {
        get() {
            _clientSocket
        }
        set(value) {
            _clientSocket = value
        }
    }

    private var _message: ?IMessage = None
    public mut prop Message: ?IMessage {
        get() {
            _message
        }
        set(value) {
            _message = value
        }
    }

    // 获取当前链接
    public func getConnection(): IConnection {
        return this.Connection.getOrThrow()
    }

    // 设置当前链接
    public func setConnection(connection: IConnection): Unit {
        this.Connection = connection
        println("${CjWeavePrefix}set connection")
    }

    // 得到请求IMessage
    public func getMessage(): IMessage {
        return this.Message.getOrThrow()
    }

    // 往客户端写入IMessage数据
    public func write(msg: IMessage): Unit {
        if (OptionPredicate.isNotEmpty(this.ClientSocket)) {
            try {
                var dataPack = newDataPack()
                let outData = dataPack.pack(msg)
                this.ClientSocket?.write(outData)
                println("${CjWeavePrefix}write message ${outData}")
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
        } else {
            println("${CjWeavePrefix}write message failed")
        }
    }

    // 往客户端写入IMessage数据
    public func write(data: Array<Byte>): Unit {
        var msg = newMessage()
        msg.setData(data)
        this.write(msg)
    }

    // 往客户端写入IMessage数据
    public func write(data: String): Unit {
        var msg = newMessage()
        msg.setData(data.toArray())
        this.write(msg)
    }

    // toString
    public func toString(): String {
        return "Request[connection: ${this.Connection?.toString()}, message: ${this.Message?.toString()}]"
    }

    public Reqeust(connection: IConnection, clientSocket: TcpSocket, msg: IMessage) {
        this.Connection = connection
        this.ClientSocket = clientSocket
        this.Message = msg
    }
}

// 创建请求
public func newReuqest(connection: IConnection, clientSocket: TcpSocket, msg: IMessage): IRequestBase {
    return Reqeust(connection, clientSocket, msg)
}
