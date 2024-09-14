package cjweave.cjiface

import std.collection.*

// 定义一个服务器接口
public interface IServer {
    // 启动服务器
    func start(): Unit

    // 停止服务器
    func stop(): Unit

    // 运行服务器
    func serve(): Unit

    // 路由功能
    func addRouter(msgId: UInt32, router: IRouterBase): IServer

    // 路由功能
    func addRouter(handles: HashMap<UInt32, IRouterBase>): IServer

    // toString
    func toString(): String
}

// 定义一个服务器接口的基类
public interface IServerBase <: IServer {}
