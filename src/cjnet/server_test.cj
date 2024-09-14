package cjweave.cjnet

import std.net.*
import std.time.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*
import cjweave.cjutil.*

@Test
class ServerTests {
    @TestCase
    func testServer() {
        // 启动配置
        GlobalConfig.refresh()
        // 启动服务端
        spawn {
            newServer().addRouter(0, DefaultRouter()).addRouter(1, WriteBackRouter()).start()
        }

        while (true) {
            sleep(Duration.millisecond * 500)
        }
    }

    @TestCase
    func testServerClient() {
        // 启动配置
        GlobalConfig.refresh()
        // 启动服务端
        spawn {
            newServer().addRouter(0, DefaultRouter()).addRouter(1, WriteBackRouter()).start()
        }
        sleep(Duration.millisecond * 500)

        // 启动10个客户端
        for (i in 1000..1100) {
            spawn {
                testClient(UInt8(i))
            }
        }
        while (true) {
            sleep(Duration.millisecond * 500)
        }
    }

    func testClient(index: UInt8) {
        let client = TcpSocket(GlobalConfig.Host, GlobalConfig.TcpPort)
        client.connect()
        var clientCount: UInt8 = index
        spawn {
            while (true) {
                // 读取服务端发送数据，拆包处理
                var dataPack = newDataPack()
                var headLen = Int64(dataPack.getHeadLen())
                var headBuffer = Array<Byte>(headLen, repeat: 0)
                var headCount = client.read(headBuffer)

                if (headCount == headLen) { // 头消息
                    var msg = dataPack.unPack(headBuffer)
                    println("[testClient]收到Server消息头信息：${msg.getMsgId()}  ${msg.getMsgLen()}")
                    // 继续读取data内容
                    var dataLen = Int64(msg.getMsgLen())
                    if (dataLen > 0) {
                        var dataBuffer = Array<Byte>(dataLen, repeat: 0)
                        var dataCount = client.read(dataBuffer)
                        if (dataCount == Int64(dataLen)) {
                            msg.setData(dataBuffer)
                            println("[testClient]收到Server消息内容：${msg.getData()}")
                        } else {
                            println("[testClient]收到Server消息头内容[非标准消息]：${dataBuffer}")
                        }
                    } else {
                        println("[testClient]Server消息内容为空")
                    }
                } else if (headCount > 0) {
                    println("[testClient]收到Server消息头信息[非标准消息]：${headCount}")
                } else {
                    sleep(Duration.millisecond * 500)
                }
            }
        }
        while (true) {
            println("client ${index} sending ${clientCount}....")
            // 发送数据，封包处理
            var dataPack = newDataPack()
            var msg = newMessage()
            msg.setMsgId(UInt32(clientCount))
            msg.setData(Array<Byte>(10, repeat: clientCount))
            let outData = dataPack.pack(msg)
            client.write(outData)
            // socket.write(Array<Byte>([1, 2, 3]))
            clientCount++
            if (clientCount > 254) {
                // break
                clientCount = index
            }
            sleep(Duration.millisecond * 500)
        }
    }
}
