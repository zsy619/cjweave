package cjweave.cjutil

import encoding.json.stream.*
import serialization.serialization.*
import cjweave.cjiface.IServer
import encoding.json.*
import std.fs.*
import std.convert.*

public struct WeaveConfig <: Serializable<WeaveConfig> {
    public var TcpServer: ?IServer = None // 全局Server对象
    public var Host: String = "0.0.0.0" // 当前服务器主机监听的IP
    public var TcpPort: UInt16 = 9090 // 当前服务器主机监听的端口
    public var TcpVersion: String = "IPv4" // 当前服务器主机监听的协议版本
    public var Name: String = "CjWeave Server App" // 当前服务的名称
    public var Version: String = "v1.0.0" // 当前CjWeave的版本号
    public var MaxConn: Int32 = 1000 // 当前服务器主机允许的最大连接数
    public var MaxPackageSize: Int64 = 4096 // 当前服务器主机允许的最大数据包大小
    public var WorkerPoolSize: UInt32 = 100 // 当前工作池的数量
    public var MaxWorkerTaskLen: UInt32 = 1024 // 每个worker对应消息队列的长度

    public func serialize(): DataModel {
        return DataModelStruct().add(field<String>("host", Host)).add(field<UInt16>("tcpPort", TcpPort)).add(
            field<String>("tcpVersion", TcpVersion)).add(field<String>("name", Name)).add(
            field<String>("version", Version)).add(field<Int32>("maxConn", MaxConn)).add(
            field<Int64>("maxPackageSize", MaxPackageSize)).add(field<UInt32>("workerPoolSize", WorkerPoolSize)).add(
            field<UInt32>("maxWorkerTaskLen", MaxWorkerTaskLen))
    }

    public static func deserialize(dm: DataModel): WeaveConfig {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = WeaveConfig()
        result.Host = String.deserialize(dms.get("host"))
        result.TcpPort = UInt16.deserialize(dms.get("tcpPort"))
        result.TcpVersion = String.deserialize(dms.get("tcpVersion"))
        result.Name = String.deserialize(dms.get("name"))
        result.Version = String.deserialize(dms.get("version"))
        result.MaxConn = Int32.deserialize(dms.get("maxConn"))
        result.MaxPackageSize = Int64.deserialize(dms.get("maxPackageSize"))
        result.WorkerPoolSize = UInt32.deserialize(dms.get("workerPoolSize"))
        result.MaxWorkerTaskLen = UInt32.deserialize(dms.get("maxWorkerTaskLen"))
        return result
    }

    public func toJson(w: JsonWriter): Unit {
        w.startObject()
        w.writeName("host").writeValue(Host)
        w.writeName("tcpPort").writeValue(TcpPort)
        w.writeName("tcpVersion").writeValue(TcpVersion)
        w.writeName("name").writeValue(Name)
        w.writeName("version").writeValue(Version)
        w.writeName("maxConn").writeValue(MaxConn)
        w.writeName("maxPackageSize").writeValue(MaxPackageSize)
        w.writeName("workerPoolSize").writeValue(WorkerPoolSize)
        w.writeName("maxWorkerTaskLen").writeValue(MaxWorkerTaskLen)
        w.endObject()
    }

    public mut func refresh(): Unit {
        if (!Directory.exists(WeaveConfigPath)) {
            Directory.create(WeaveConfigPath)
        }
        if (!this.reload()) {
            this.save()
        }
        println("配置文件加载成功")
    }

    // 从配置文件加载参数
    public mut func reload(): Bool {
        // 从conf/global.json中读取配置
        let exist = File.exists(WeaveConfigFile)
        if (!exist) {
            println("配置文件不存在，使用默认配置")
            false
        } else {
            let bytes = File.readFrom(WeaveConfigFile)
            var jv = JsonValue.fromStr(String.fromUtf8(bytes))
            var dm = DataModel.fromJson(jv)
            var glbConf = WeaveConfig.deserialize(dm)
            this.Host = glbConf.Host
            this.TcpPort = glbConf.TcpPort
            this.TcpVersion = glbConf.TcpVersion
            this.Name = glbConf.Name
            this.Version = glbConf.Version
            this.MaxConn = glbConf.MaxConn
            this.MaxPackageSize = glbConf.MaxPackageSize
            this.WorkerPoolSize = glbConf.WorkerPoolSize
            this.MaxWorkerTaskLen = glbConf.MaxWorkerTaskLen
            true
        }
    }

    // 序列化并保存到配置文件
    public mut func save(): Unit {
        var dm = this.serialize()
        var jo = dm.toJson().asObject()
        println(jo.toJsonString())
        var file = File(WeaveConfigFile, OpenOption.Create(false))
        file.write(jo.toJsonString().toArray())
        file.close()
    }

    public mut func setServer(server: IServer) {
        TcpServer = server
    }
    public mut func setHost(host: String) {
        Host = host
    }
    public mut func setTcpPort(port: UInt16) {
        TcpPort = port
    }
    public mut func setName(name: String) {
        Name = name
    }
    public mut func setVersion(version: String) {
        Version = version
    }
    public mut func setMaxConn(maxConn: Int32) {
        MaxConn = maxConn
    }
    public mut func setMaxPackageSize(maxPackageSize: Int64) {
        MaxPackageSize = maxPackageSize
    }

    public static func typeName(): String {
        "WeaveConfig"
    }
}

public var GlobalConfig: WeaveConfig = WeaveConfig()
