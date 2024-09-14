package cjweave.cjiface

import std.net.TcpServerSocket

// 处理函数接口
public interface IHandle {
    func handle(conn: ?TcpServerSocket, data: Array<Byte>, len: Int64): Unit
}

// 处理函数接口
public interface IHandleBase <: IHandle {}
