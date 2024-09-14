package cjweave.cjutil

import std.net.*

extend TcpServerSocket {
    public func acceptLoop(handler: (TcpSocket) -> Unit) {
        while (true) {
            let client = this.accept()
            spawn {
                try {
                    handler(client)
                } finally {
                    client.close()
                }
            }
        }
    }
}
