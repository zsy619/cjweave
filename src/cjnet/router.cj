package cjweave.cjnet

import cjweave.cjiface.*
import std.convert.*
import cjweave.cjutil.*

public abstract class BaseRouter <: IRouterBase {
    // 处理业务之前钩子方法
    public open func preHandle(request: IRequest<IConnection, IMessage>): Unit {
        println("${CjWeavePrefix}BaseRouter preHandle ${request.toString()}\r")
    }

    // 处理业务
    public open func handle(request: IRequest<IConnection, IMessage>): Unit {
        println("${CjWeavePrefix}BaseRouter handle ${request.toString()}\r")
    }

    // 处理业务之后钩子方法
    public open func postHandle(request: IRequest<IConnection, IMessage>): Unit {
        println("${CjWeavePrefix}BaseRouter postHandle ${request.toString()}\r")
    }

    // toString
    public open func toString(): String {
        return "BaseRouter"
    }
}

public class DefaultRouter <: BaseRouter {
    // 处理业务之前钩子方法
    public override func preHandle(request: IRequest<IConnection, IMessage>): Unit {
        println("${CjWeavePrefix}DefaultRouter preHandle\r")
        super.preHandle(request)
    }

    // 处理业务
    public override func handle(request: IRequest<IConnection, IMessage>): Unit {
        println("${CjWeavePrefix}DefaultRouter handle\r")
        super.handle(request)
    }

    // 处理业务之后钩子方法
    public override func postHandle(request: IRequest<IConnection, IMessage>): Unit {
        println("${CjWeavePrefix}DefaultRouter postHandle\r")
        super.postHandle(request)
    }

    // toString
    public override func toString(): String {
        return "DefaultRouter"
    }
}

public class WriteBackRouter <: BaseRouter {
    // 处理业务之前钩子方法
    public override func preHandle(request: IRequest<IConnection, IMessage>): Unit {
        println("${CjWeavePrefix}WriteBackRouter preHandle\r")
        request.write("WriteBackRouter preHandle")
    }

    // 处理业务
    public override func handle(request: IRequest<IConnection, IMessage>): Unit {
        println("${CjWeavePrefix}WriteBackRouter handle\r")
        request.write("WriteBackRouter handle")
    }

    // 处理业务之后钩子方法
    public override func postHandle(request: IRequest<IConnection, IMessage>): Unit {
        println("${CjWeavePrefix}WriteBackRouter postHandle\r")
        request.write("WriteBackRouter postHandle")
    }

    // toString
    public override func toString(): String {
        return "WriteBackRouter"
    }
}
