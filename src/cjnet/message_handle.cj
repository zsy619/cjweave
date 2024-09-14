package cjweave.cjnet

import std.net.*
import cjweave.cjiface.*
import cjweave.xtool.*
import cjweave.cjutil.*
import std.collection.*

public class MessageHandle <: IMessageHandleBase {
    private var _apis: HashMap<UInt32, IRouterBase> = HashMap<UInt32, IRouterBase>()
    public mut prop Apis: HashMap<UInt32, IRouterBase> {
        get() {
            _apis
        }
        set(value) {
            _apis = value
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
            println("${CjWeavePrefix}doMessageHandle not find ${msgId}")
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
}

public func newMessageHandle(): IMessageHandleBase {
    return MessageHandle()
}

public func newDefaultMessageHandle(): IMessageHandleBase {
    let msg = newMessageHandle()

    return msg
}
