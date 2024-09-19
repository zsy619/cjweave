package cjweave.cjnet

import std.net.*
import std.time.*
import std.sync.*
import std.unittest.testmacro.*
import cjweave.cjutil.*
import std.unittest.*

@Test
class ServerTests {
    @TestCase
    func testServer() {
        // 1.设置默认配置
        /*
        {
		"host": "0.0.0.0",
		"tcpPort": 9090,
		"tcpVersion": "IPv4",
		"name": "CjWeave Server App",
		"version": "v1.0.0",
		"maxConn": 1000,
		"maxPackageSize": 4096,
		"workerPoolSize": 100,
		"maxWorkerTaskLen": 1024
		}
         */
        GlobalConfig.refresh()
        // 2.启动一个服务端
        spawn {
            // 初始化服务端
            // 添加处理路由（根据msgId进行路由匹配）
            // 启动服务端
            newServer().addRouter(0, DefaultRouter()).addRouter(1, WriteBackRouter()).start()
        }

        while (true) {
            sleep(Duration.millisecond * 500)
        }
    }

    @TestCase
    func testServerClient() {
        // 1.设置默认配置
        GlobalConfig.refresh()
        // 2.启动一个服务端
        spawn {
            // 初始化服务端
            // 添加处理路由（根据msgId进行路由匹配）
            // 启动服务端
            newServer().addRouter(0, DefaultRouter()).addRouter(1, WriteBackRouter()).start()
        }
        // 休眠，等待创建客户端
        sleep(Duration.millisecond * 500)

        // 3.启动50个客户端
        for (i in 10..60) {
            spawn {
                testClient(UInt8(i))
            }
        }

        while (true) {
            sleep(Duration.millisecond * 500)
        }
    }

    func testClient(index: UInt8) {
        // 1.创建客户端
        let client = TcpSocket(GlobalConfig.Host, GlobalConfig.TcpPort)
        client.connect()
        // 2.异步读取服务端消息
        let futureReader = spawn {
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
        // 3.异步发送客户端消息
        let futureWriter = spawn {
            var clientCount: UInt8 = index
            while (true) {
                println("client ${index} sending ${clientCount}....")
                // 发送数据，封包处理
                var dataPack = newDataPack()
                var msg = newMessage()
                msg.setMsgId(UInt32(clientCount))
                msg.setData(Array<Byte>(10, repeat: clientCount))
                let outData = dataPack.pack(msg)
                client.write(outData)
                clientCount++
                if (clientCount > 1) {
                    clientCount = index
                }
                // 设置发送间隔
                sleep(Duration.millisecond * 500)
            }
        }

        futureReader.get()
        futureWriter.get()
    }
}
