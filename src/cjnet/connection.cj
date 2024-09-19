package cjweave.cjnet

import std.net.*
import std.sync.*
import cjweave.xtool.*
import cjweave.cjiface.*
import cjweave.cjutil.*
import std.collection.concurrent.*

// 链接模块
public class Connection <: IConnectionBase {
    private var _exitChan: BlockingQueue<Bool> = BlockingQueue<Bool>()
    // 链接退出通知
    public mut prop ExitChan: BlockingQueue<Bool> {
        get() {
            _exitChan
        }
        set(value) {
            _exitChan = value
        }
    }

    private var _msgChann: BlockingQueue<Array<Byte>> = BlockingQueue<Array<Byte>>()
    // 无缓冲管道，用于读写之间的消息通讯
    public mut prop MsgChann: BlockingQueue<Array<Byte>> {
        get() {
            _msgChann
        }
        set(value) {
            _msgChann = value
        }
    }

    private var _conn: ?TcpServerSocket = None
    // 链接
    public mut prop Conn: ?TcpServerSocket {
        get() {
            _conn
        }
        set(value) {
            _conn = value
        }
    }

    private var _connId: UInt32 = 0
    // 链接ID
    public mut prop ConnId: UInt32 {
        get() {
            _connId
        }
        set(value) {
            _connId = value
        }
    }

    private var _isClosed: Bool = false
    // 状态
    public mut prop IsClosed: Bool {
        get() {
            _isClosed
        }
        set(value) {
            _isClosed = value
        }
    }

    private var _msgHandle: ?IMessageHandleBase = None
    // 消息处理路由
    public mut prop MsgHandle: ?IMessageHandleBase {
        get() {
            _msgHandle
        }
        set(value) {
            _msgHandle = value
        }
    }

    // 链接的读业务
    func startReader() {
        println("${CjWeavePrefix}startReader() ConnId=${this.ConnId}")
        try {
            let conn = this.Conn.getOrThrow()
            while (true) {
                try {
                    let client = conn.accept()
                    spawn {
                        this.startReaderClient(client)
                    }
                } catch (ex: SocketException) {
                    ex.printStackTrace()
                    println("${CjWeavePrefix}startReader() ConnId=${this.ConnId} SocketException ${ex.toString()}")
                }
            }
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
        this.stop()
    }

    func startReaderClient(client: TcpSocket): Unit {
        while (true) {
            var index: Int64 = 1
            try {
                var dataPack = newDataPack()
                var headLen = Int64(dataPack.getHeadLen())
                var headBuffer = Array<Byte>(headLen, repeat: 0)
                var headCount = client.read(headBuffer)
                if (headCount == headLen) { // 头消息
                    var msg = dataPack.unPack(headBuffer)
                    println("${CjWeavePrefix}startReader() 收到消息头信息：${msg.getMsgId()}  ${msg.getMsgLen()}")
                    // 继续读取data内容
                    var dataLen = Int64(msg.getMsgLen())
                    if (dataLen > 0) {
                        var dataBuffer = Array<Byte>(dataLen, repeat: 0)
                        var dataCount = client.read(dataBuffer)
                        if (dataCount == Int64(dataLen)) {
                            msg.setData(dataBuffer)
                            println("${CjWeavePrefix}startReader() index = ${index} 收到消息内容：${msg.getData()}")
                            index++
                            let req = newReuqest(this, client, msg)
                            this.router(req)
                        } else {
                            println("${CjWeavePrefix}startReader() 收到消息头内容[非标准消息]：${dataBuffer}")
                        }
                    } else {
                        println("${CjWeavePrefix}startReader() 消息内容为空")
                    }
                } else if (headCount > 0) {
                    println("${CjWeavePrefix}startReader() 收到消息头信息[非标准消息]：${headCount}")
                } else {
                    sleep(Duration.millisecond * 500)
                }
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
        }
    }

    // 执行注册路由的方法
    func router(reqeust: IRequestBase): Unit {
        if (!OptionPredicate.isEmpty(this.MsgHandle)) {
            spawn {
                // 开启了工作池机制
                if (GlobalConfig.MaxPackageSize > 0) {
                    this.MsgHandle?.sendMsgToTaskQueue(reqeust)
                } else {
                    this.MsgHandle?.doMessageHandle(reqeust)
                }
            }
        } else {
            println("${CjWeavePrefix}router() MsgHandle is None")
        }
    }

    // 调用当前链接所绑定的HandleAPI
    func handle(buf: Array<Byte>, count: Int): Unit {
        println("${CjWeavePrefix}handle() buf=${buf} count=${count}")
        // if (!OptionPredicate.isEmpty(this.HandleAPI)) {
        //     this.HandleAPI?.handle(this.Conn, buf, count)
        // } else {
        //     println("${CjWeavePrefix}handle() this.HandleAPI is None")
        // }
    }

    // 启动链接
    public func start(): Unit {
        spawn {
            startReader()
        }
        println("${CjWeavePrefix}conn start() ConnId=${this.ConnId}")
    }

    // 停止链接
    public func stop(): Unit {
        if (this.IsClosed) {
            println("${CjWeavePrefix}conn stop() ConnId=${this.ConnId} is closed")
            return
        }
        this.ExitChan.enqueue(true)
        this.IsClosed = true
        this.Conn?.close()
        println("${CjWeavePrefix}conn stop() ConnId=${this.ConnId}")
    }

    // 获取链接
    public func getTCPConn(): ?TcpServerSocket {
        return this.Conn
    }

    // 获取链接ID
    public func getConnId(): UInt32 {
        this.ConnId
    }

    // 获取远程客户端TCP状态 IP Port
    public func remoteAddr(): ?SocketAddress {
        if (!this.Conn.isSome()) {
            return Option<SocketAddress>.None
        }
        return this.Conn?.localAddress
    }

    // 数据发送
    public func send(data: Array<Byte>): SocketException {
        println("${CjWeavePrefix}send data ${data}")
        return SocketException()
    }

    // toString
    public func toString(): String {
        return "Connection [ConnId=${this.ConnId}, IsClosed=${this.IsClosed}]"
    }
}

// 创建链接
public func newConnection(conn: TcpServerSocket, connId: UInt32, msgHandle!: ?IMessageHandleBase = None,
    isClosed!: Bool = false): IConnection {
    let conntion = Connection()
    conntion.Conn = conn
    conntion.ConnId = connId
    conntion.IsClosed = isClosed
    conntion.MsgHandle = msgHandle
    return conntion
}
