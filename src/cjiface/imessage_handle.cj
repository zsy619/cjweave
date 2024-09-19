package cjweave.cjiface

// 消息处理接口
public interface IMessageHandle<T1, T2> where T1 <: IRequestBase, T2 <: IRouterBase {
    // 调度执行对应的Router消息处理方法
    func doMessageHandle(request: T1): Unit

    // 为消息添加具体处理逻辑
    func addRouter(msgId: UInt32, router: T2): Unit

    // toString
    func toString(): String

    // 启动一个worker工作池（开启工作池的动作只能发生一次）
    func startWorkerPool(): Unit

	// 将消息发送到任务队列中
    func sendMsgToTaskQueue(request: IRequestBase): Unit
}

// 消息处理接口
public interface IMessageHandleBase <: IMessageHandle<IRequestBase, IRouterBase> {}
