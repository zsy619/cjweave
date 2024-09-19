package cjweave.cjnet

import cjweave.cjiface.*
import std.net.*
import cjweave.cjutil.*
import std.collection.*
import cjweave.xtool.*

// 接口的实现类，定义一个Server服务器模块，实现服务器的启动、停止和运行等方法
public class Server <: IServerBase {
    private var _name: String = GlobalConfig.Name
    // 服务器的名字
    public mut prop Name: String {
        get() {
            _name
        }
        set(value) {
            _name = value
        }
    }

    private var _ipVersion: String = GlobalConfig.TcpVersion
    // 服务器绑定的版本
    public mut prop IPVersion: String {
        get() {
            _ipVersion
        }
        set(value) {
            _ipVersion = value
        }
    }

    private var _ip: String = GlobalConfig.Host
    // 服务器的主机地址
    public mut prop IP: String {
        get() {
            _ip
        }
        set(value) {
            _ip = value
        }
    }

    private var _port: UInt16 = GlobalConfig.TcpPort
    // 服务器的端口号
    public mut prop Port: UInt16 {
        get() {
            _port
        }
        set(value) {
            _port = value
        }
    }

    private var _msgHandle: ?IMessageHandleBase = None
    // 消息处理路由
    public mut prop MsgHandle: ?IMessageHandleBase {
        get() {
            _msgHandle
        }
        set(value) {
            _msgHandle = value
        }
    }

    // 启动服务器
    public func start(): Unit {
        println("${CjWeavePrefix}server start IP = ${this.IP} Port = ${this.Port} is starting...")
        // 创建ServerSocket对象
        // 监听服务地址
        // 阻塞等的客户端链接，处理客户端链接业务（读写）
        spawn {
			// 开启消息队列
			this.MsgHandle?.startWorkerPool()
			
            var connId: UInt32 = 88888888
            try {
                let socketAddress = IPSocketAddress.parse("${this.IP}:${this.Port}")
                let serverSocket = TcpServerSocket(bindAt: socketAddress)
                serverSocket.bind()
                println("${CjWeavePrefix}server start IP = ${this.IP} Port = ${this.Port} started")

                // 处理客户端链接业务
                let dealConn = newConnection(serverSocket, connId, msgHandle: this.MsgHandle)
                connId++
                spawn {
                    dealConn.start()
                }
            } catch (ex: SocketException) {
                ex.printStackTrace()
                println("${CjWeavePrefix}Server start catch: connId = ${connId} error = ${ex.toString()}")
            } finally {
                println("${CjWeavePrefix}Server start finally: connId = ${connId}")
            }
        }
        println("${CjWeavePrefix}server start")
    }

    // 停止服务器
    public func stop(): Unit {
        println("${CjWeavePrefix}server stop Name = ${this.Name} IP = ${this.IP} Port = ${this.Port} is stopping...")
        println("${CjWeavePrefix}server stop")
    }

    // 运行服务器
    public func serve(): Unit {
        // 启动
        this.start()

        // 阻塞
        while (true) {}

        println("${CjWeavePrefix}server serve")
    }

    // 路由功能
    public func addRouter(msgId: UInt32, router: IRouterBase): IServer {
        if (OptionPredicate.isEmpty(this.MsgHandle)) {
            this.MsgHandle = newMessageHandle()
        }
        this.MsgHandle?.addRouter(msgId, router)
        println("${CjWeavePrefix}server add msgHandle: msgId = ${msgId},router = ${router.toString()}")
        this
    }

    // 路由功能
    public func addRouter(handles: HashMap<UInt32, IRouterBase>): IServer {
        if (OptionPredicate.isEmpty(this.MsgHandle)) {
            this.MsgHandle = newMessageHandle()
        }
        for (handle in handles) {
            this.MsgHandle?.addRouter(handle[0], handle[1])
            println("${CjWeavePrefix}server add msgHandle: msgId = ${handle[0]},router = ${handle[1].toString()}")
        }
        this
    }

    // toString
    public func toString(): String {
        return "Server [Name= ${this.Name}, IPVersion= ${this.IPVersion}, IP= ${this.IP}, Port= ${this.Port}]"
    }

    // 初始化Server
    public init(name: String, ip!: String = GlobalConfig.Host, port!: UInt16 = GlobalConfig.TcpPort,
        ipVersion!: String = GlobalConfig.TcpVersion) {
        this.Name = name
        this.IPVersion = ipVersion
        this.IP = ip
        this.Port = port
        this.MsgHandle = None
    }
}

// 创建Server对象
public func newServer(name!: String = GlobalConfig.Name, ip!: String = GlobalConfig.Host,
    port!: UInt16 = GlobalConfig.TcpPort, ipVersion!: String = GlobalConfig.TcpVersion): IServer {
    println(
        ###'
                 _________________________________________                                
               .'  _____________________________________  '.                              
              "| .'                                     '. |                              
              "| |                                       | |                              
              "| |  {                                    | |                              
              "| |    cout << "Vopec_" << endl;          | |                              
              "| |    return 0;                          | |                              
              "| |  }                                    | |                              
              "| |                                       | |                              
              "| '._____________________________________.' |`*.                           
              "'._________________________________________.'   `.                         
               """"""""""""""""""|.   .|""""""""""""""""""      '                         
          ----------------------__|   |__------------------------`--------------          
         /                     /_________\.......-----------.     `.            \         
        /       _________________________________________    )       `.          \        
       /      "/ .-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.  ---  \_.'         _;___       \       
      /      "/ .---.-.-.-.-.-.-.-.-.-.-.-.-.-.-.--.  .-. \          /" \  \       \      
     /      "/ .-.-. .---.-.-.-.-.--.-.-.-.-.-`__`. .-.-.-.\         \""    \       \     
    /      "/ .-.-. .-----.-.-.-.-.-.-.-.-.-.-.-----. .-.-. \         \""    \       \    
   /      ":-------------------------------------------------:         \""    \       \   
  /       "`---._.-------------------------------------._.---'          '=---='        \  
 /                                                                                      \ 
------------------------------------------------------------------------------------------
		'###
    )
    return Server(name, ip: ip, port: port, ipVersion: ipVersion)
}
