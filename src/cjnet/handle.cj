package cjweave.cjnet

import std.net.*
import cjweave.cjiface.*
import cjweave.xtool.*
import cjweave.cjutil.*

// 默认处理函数
public class DefaultHandle <: IHandle {
    public func handle(conn: ?TcpServerSocket, data: Array<Byte>, len: Int64): Unit {
        if (OptionPredicate.isEmpty(conn)) {
            throw SocketException("conn is null")
        }
        println("${CjWeavePrefix}DefaultHandle handle len ${len} bytes: ${data[0..len]}")
    }
}

// 创建默认处理函数
public func newDefaultHandle(): Option<IHandle> {
    return Some(DefaultHandle())
}
