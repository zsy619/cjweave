package cjweave.cjiface

// 路由接口
public interface IRouter<T> where T <: IRequest<IConnection, IMessage> {
    // 处理业务之前钩子方法
    func preHandle(request: T): Unit

    // 处理业务
    func handle(request: T): Unit

    // 处理业务之后钩子方法
    func postHandle(request: T): Unit

    // toString
    func toString(): String
}

// 路由接口的基础接口
public interface IRouterBase <: IRouter<IRequest<IConnection, IMessage>> {}
