package cjweave.xtool

import std.sync.*
import std.time.*
import std.collection.concurrent.*
import std.collection.*

// 通道的接口，可用于发送和接收消息。
public interface IPcpChannel<T> {
    // 向通道发送消息。
    func send(msg: T): Unit

    // 从通道接收消息。
    func recv(): T
}

// 可用于发送和接收消息的通道。
// 通道阻塞，如果缓冲区已满，将阻塞发送方，如果缓冲区为空，将阻塞接收方。
public class PcpChannel<T> <: IPcpChannel<T> {
    let futsIns = ArrayList<Future<T>>() //存储生产者线程的返回值
    let futsOuts = ArrayList<Future<T>>() //存储消费者线程的返回值
    let _channel: BlockingQueue<T>

    // 向通道发送消息。
    public func send(msg: T): Unit {
        let fut: Future<T> = spawn {
            _channel.enqueue(msg) //阻塞的加入任务
            msg
        }
        futsIns.append(fut)
    }

    // 从通道接收消息。
    public func recv(): T {
        let fut: Future<T> = spawn {
            _channel.dequeue() //阻塞的取出任务
        }
        futsOuts.append(fut)
        return fut.get()
    }

    // 初始化
    public init(bufferSize: Int) {
        if (bufferSize <= 0) {
            throw Exception("缓冲区大小必须大于0")
        }
        this._channel = BlockingQueue<T>(bufferSize)
    }
}

// 创建一个具有给定缓冲区大小的新通道。
public func newPcpChannel<T>(bufferSize: Int): IPcpChannel<T> {
    return PcpChannel<T>(bufferSize)
}
