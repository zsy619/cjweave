package cjweave.cjiface

// 消息处理接口
public interface IMessageHandle<T1, T2> where T1 <: IRequestBase, T2 <: IRouterBase {
    // 调度执行对应的Router消息处理方法
    func doMessageHandle(request: T1): Unit

    // 为消息添加具体处理逻辑
    func addRouter(msgId: UInt32, router: T2): Unit

    // toString
    func toString(): String
}

// 消息处理接口
public interface IMessageHandleBase <: IMessageHandle<IRequestBase, IRouterBase> {}
