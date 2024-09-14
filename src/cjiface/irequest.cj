package cjweave.cjiface

// 请求接口
public interface IRequest<T1, T2> where T1 <: IConnection, T2 <: IMessage {
    // 获取当前链接
    func getConnection(): T1

    // 设置当前链接
    func setConnection(connection: T1): Unit

    // 得到请求IMessage
    func getMessage(): T2

    // 往客户端写入IMessage数据
    func write(msg: T2): Unit

    // 往客户端写入IMessage数据
    func write(data: Array<Byte>): Unit

    // 往客户端写入IMessage数据
    func write(data: String): Unit

    // toString
    func toString(): String
}

// 请求接口
public interface IRequestBase <: IRequest<IConnection, IMessage> {}
