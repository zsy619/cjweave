package cjweave.xtool

import std.net.*
import std.time.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.concurrent.*
import std.collection.*

@Test
class RawSocketTests {
    @TestCase
    func testRawSocket() {
        try {
            let server = RawSocket(SocketDomain.IPV4, SocketType.STREAM, ProtocolType.TCP)
            let client = RawSocket(SocketDomain.IPV4, SocketType.STREAM, ProtocolType.TCP)
			// [2, 0]: AF_INET, [32, 121]: port, [127, 0, 0, 1]: IP address, [0, 0, 0, 0, 0, 0, 0, 0]: reserved 6 bytes
            let array: Array<Byte> = [2, 0, 39, 50, 127, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0]
            // array[0..2] = getSocketFamily(AF_INET)
            let s_addr = RawAddress(array)
            server.bind(s_addr)
            server.listen(1000)
            spawn {
                client.connect(s_addr)
                let msg_send: Array<Byte> = "Hello, cangjie server.".toArray()
                client.send(msg_send, 0)
            }
            sleep(Duration.second)
            let server_com = server.accept()
            let msg_arr = Array<Byte>(2, repeat: 0)
            let msg_size = server_com.receive(msg_arr, 0)
            let msg_recv = String.fromUtf8(msg_arr.slice(0, msg_size))
            client.close()
            server.close()
            @Expect(msg_recv, "Hello, cangjie server.")
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }
}
