package cjweave.cjnet

import std.net.*
import std.time.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*
import cjweave.cjutil.*

@Test
class DataPackTests {
    @TestCase
    func testPack() {
        var dataPack = newDataPack()
        var message = newMessage()
        message.setMsgId(1528963)
        var data = "我爱你中国！"
        message.setData(data.toArray())
        message.setMsgLen(UInt32(data.size))
        var out = dataPack.pack(message)
        println(out)
        // [18, 0, 0, 0, 131, 84, 23, 0, 230, 136, 145, 231, 136, 177, 228, 189, 160, 228, 184, 173, 229, 155, 189, 239, 188, 129]
    }

    @TestCase
    func testunPack() {
        var data: Array<Byte> = [18, 0, 0, 0, 131, 84, 23, 0, 230, 136, 145, 231, 136, 177, 228, 189, 160, 228, 184,
            173, 229, 155, 189, 239, 188, 129]
        var dataPack = newDataPack()
        var msg = dataPack.unPack(data)
        println(msg.getMsgId()) //1528963
        println(msg.getMsgLen()) //13
    }

    @TestCase
    func testServerClient() {
        try {
            // 服务端
            let socketAddress = IPSocketAddress.parse("${GlobalConfig.Host}:${GlobalConfig.TcpPort}")
            let serverSocket = TcpServerSocket(bindAt: socketAddress)
            serverSocket.bind()
            // 从客户端端读取
            spawn {
                while (true) {
                    let client = serverSocket.accept()
                    spawn {
                        while (true) {
                            // 服务端读取数据，拆包处理
                            var dataPack = newDataPack()
                            var headLen = Int64(dataPack.getHeadLen())
                            var headBuffer = Array<Byte>(headLen, repeat: 0)
                            var headCount = client.read(headBuffer)
                            if (headCount == headLen) { // 头消息
                                var msg = dataPack.unPack(headBuffer)
                                println("[testTcpSocket]Server收到消息头信息：${msg.getMsgId()}  ${msg.getMsgLen()}")
                                // 继续读取data内容
                                var dataLen = Int64(msg.getMsgLen())
                                if (dataLen > 0) {
                                    var dataBuffer = Array<Byte>(dataLen, repeat: 0)
                                    var dataCount = client.read(dataBuffer)
                                    if (dataCount == Int64(dataLen)) {
                                        msg.setData(dataBuffer)
                                        println("[testTcpSocket]Server收到消息内容：${msg.getData()}")
                                    } else {
                                        println("[testTcpSocket]Server收到消息头内容[非标准消息]：${dataBuffer}")
                                    }
                                } else {
                                    println("[testTcpSocket]Server消息内容为空")
                                }
                            } else if (headCount > 0) {
                                println("[testTcpSocket]Server收到消息头信息[非标准消息]：${headCount}")
                            } else {
                                sleep(Duration.millisecond * 500)
                            }
                        }
                    }
                }
            }

            sleep(Duration.millisecond * 500)

            // 客户端
            // 创建socketTcp
            let client = TcpSocket(GlobalConfig.Host, GlobalConfig.TcpPort)
            client.connect()

            spawn {
                // 客户端写入
                var dataPack = newDataPack()
                for (i in 198000..199000) {
                    var msg = newMessage(UInt32(i), "我爱你中国！")
                    var buffer = dataPack.pack(msg)
                    client.write(buffer)
                }
            }

            // spawn {
            //     // 客户端读取数据，拆包处理
            //     var dataPack = newDataPack()
            //     var headLen = Int64(dataPack.getHeadLen())
            //     while (true) {
            //         var headBuffer = Array<Byte>(headLen, repeat: 0)
            //         var headCount = client.read(headBuffer)
            //         if (headCount == headLen) { // 头消息
            //             var msg = dataPack.unPack(headBuffer)
            //             println("[testTcpSocket]Client收到消息头信息：${msg.getMsgId()}  ${msg.getMsgLen()}")
            //             // 继续读取data内容
            //             var dataLen = Int64(msg.getMsgLen())
            //             if (dataLen > 0) {
            //                 var dataBuffer = Array<Byte>(dataLen, repeat: 0)
            //                 var dataCount = client.read(dataBuffer)
            //                 if (dataCount > 0) {
            //                     msg.setData(dataBuffer)
            //                     println("[testTcpSocket]Client收到消息内容：${msg.getData()}")
            //                 }
            //             }
            //         } else {
            //             println("[testTcpSocket]Client收到消息头信息[非标准消息]：${headCount}")
            //         }
            //     }
            // }

            while (true) {
                sleep(Duration.millisecond * 500)
            }
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }
}
