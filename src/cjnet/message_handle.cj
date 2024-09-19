package cjweave.cjnet

import std.net.*
import cjweave.cjiface.*
import cjweave.xtool.*
import cjweave.cjutil.*
import std.collection.*
import std.collection.concurrent.*
import std.sync.*
import std.time.*
import std.collection.*

// 消息处理类
public class MessageHandle <: IMessageHandleBase {
    private var _apis: HashMap<UInt32, IRouterBase> = HashMap<UInt32, IRouterBase>()
    // 存放每个msgid对应的处理方法
    public mut prop Apis: HashMap<UInt32, IRouterBase> {
        get() {
            _apis
        }
        set(value) {
            _apis = value
        }
    }

    private var _taskQueue: Array<BlockingQueue<IRequestBase>> = Array<BlockingQueue<IRequestBase>>()
    // 负责worker取任务的消息队列
    public mut prop TaskQueue: Array<BlockingQueue<IRequestBase>> {
        get() {
            _taskQueue
        }
        set(value) {
            _taskQueue = value
        }
    }

    private var _workerPoolSize: UInt32 = 100
    // 业务工作Worker池的worker数量
    public mut prop WorkerPoolSize: UInt32 {
        get() {
            _workerPoolSize
        }
        set(value) {
            _workerPoolSize = value
        }
    }

    // 调度执行对应的Router消息处理方法
    public func doMessageHandle(request: IRequestBase): Unit {
        var msgId = request.getMessage().getMsgId()
        if (this.Apis.contains(msgId)) {
            var router = this.Apis[msgId]
            router.preHandle(request)
            router.handle(request)
            router.postHandle(request)
        } else {
            println("${CjWeavePrefix}doMessageHandle not find handles for msgId = ${msgId}")
        }
    }

    // 为消息添加具体处理逻辑
    public func addRouter(msgId: UInt32, router: IRouterBase): Unit {
        if (!this.Apis.contains(msgId)) {
            this.Apis[msgId] = router
        }
    }

    // toString
    public func toString(): String {
        return "MessageHandle[count = ${this.Apis.size}]"
    }

    // 启动一个worker工作池（开启工作池的动作只能发生一次）
    public func startWorkerPool(): Unit {
        // 启动工作池的动作只能发生一次
        if (this.WorkerPoolSize <= 0) {
            return
        }
        spawn {
            let list = ArrayList<Future<Unit>>()
            for (i in 0..this.WorkerPoolSize) {
                let fut = spawn {
                    // 初始化队列空间
                    this.TaskQueue[Int64(i)] = BlockingQueue<IRequestBase>(Int64(GlobalConfig.MaxWorkerTaskLen))
                    // 启动当前worker，阻塞等待消息从队列中取出
                    spawn {
                        this.startOneWorker(i, this.TaskQueue[Int64(i)])
                    }
                    println("${CjWeavePrefix}startWorkerPool ${i+1}");
                }
                list.append(fut)
            }
            for (f in list) {
                f.get()
            }
        }
        println("${CjWeavePrefix}startWorkerPool");
    }

    // 启动一个worker工作流程
    public func startOneWorker(workId: UInt32, taskQuene: BlockingQueue<IRequestBase>): Unit {
        println("${CjWeavePrefix}startOneWorker workId = ${workId} is started ...");
        // 不断阻塞等待消息队列的消息
        while (true) {
            try {
                var request = taskQuene.dequeue()
                this.doMessageHandle(request)
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
        }
    }

    // 将消息发送到任务队列中
    public func sendMsgToTaskQueue(request: IRequestBase): Unit {
		// 1.将消息平均分配给不同的Worker业务处理
		// 根据connId进行分配
		var connId = request.getConnection().getConnId()
		var workerId = connId % this.WorkerPoolSize
		println("${CjWeavePrefix}sendMsgToTaskQueue connId = ${connId} request msgId = ${request.getMessage().getMsgId()} to workerId = ${workerId}")
		// 2.将消息发送给对应的workId的队列中
		this.TaskQueue[Int64(workerId)].enqueue(request)
    }

    // 初始化
    public init() {
        this.WorkerPoolSize = GlobalConfig.WorkerPoolSize
        this.TaskQueue = Array<BlockingQueue<IRequestBase>>(Int64(this.WorkerPoolSize),
            repeat: BlockingQueue<IRequestBase>())
    }
}

// 创建消息处理类
public func newMessageHandle(): IMessageHandleBase {
    return MessageHandle()
}
