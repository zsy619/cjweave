package cjweave.cjiface

import std.net.TcpServerSocket
import std.net.SocketAddress
import std.net.SocketException

// 链接接口
public interface IConnection {
    // 启动链接
    func start(): Unit

    // 停止链接
    func stop(): Unit

    // 获取链接
    func getTCPConn(): ?TcpServerSocket

    // 获取链接ID
    func getConnId(): UInt32

    // 获取远程客户端TCP状态 IP Port
    func remoteAddr(): ?SocketAddress

    // 数据发送
    func send(data: Array<Byte>): SocketException

	// 设置链接属性
	func setProperty(key: String, val: Any): Unit

	// 获取链接属性
	func getProperty(key: String): ?Any

	// 移出链接属性
	func removeProperty(key: String): Unit

    // toString
    func toString(): String
}

// 链接接口
public interface IConnectionBase <: IConnection {}
