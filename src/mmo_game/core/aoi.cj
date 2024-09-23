package cjweave.mmo_game.core

import std.collection.*

// AOI管理模块
public class AOIManager {
    // 区域的左边界坐标
    public var minX: Int = 0
    // 区域的右边界坐标
    public var maxX: Int = 0
    // X方向格子的数量
    public var cntsX: Int = 0
    // 区域的上边界坐标
    public var minY: Int = 0
    // 区域的下边界坐标
    public var maxY: Int = 0
    // Y方向格子的数量
    public var cntsY: Int = 0
    // 区域中所有的格子集合
    // 当前区域有哪些格子HashMap key=格子ID，value=格子对象
    public var grids: HashMap<Int, Grid> = HashMap<Int, Grid>()

    // 提供一个方法，让外界通过这个方法，得到指定坐标对应的格子对象
    public AOIManager(minX: Int, maxX: Int, cntsX: Int, minY: Int, maxY: Int, cntsY: Int) {
        this.minX = minX
        this.maxX = maxX
        this.cntsX = cntsX
        this.minY = minY
        this.maxY = maxY
        this.cntsY = cntsY

        // 给AOI初始化区域的所有格子进行编号
        let width = this.gridWidth()
        let length = this.gridLength()
        for (idy in 0..cntsY) {
            for (idx in 0..cntsX) {
                // 计算格子ID，根据idx，idy编号顺序来算
                // 格子编号：id = idy * cntsX + idx
                let gridId: Int = idy * cntsX + idx
                // 给格子初始化
                let grid = newGrid(gridId, minX + idx * width, minX + (idx + 1) * width, minY + idy * length,
                    minY + (idy + 1) * length)
                // 把格子放到AOI区域的格子管理map里
                grids.put(gridId, grid)
            }
        }
    }

    // 得到每个格子在X轴方向的宽度
    private func gridWidth(): Int {
        return (maxX - minX) / cntsX
    }

    // 得到每个格子在Y轴方向的高度
    private func gridLength(): Int {
        return (maxY - minY) / cntsY
    }

    // 输出信息
    public func toString(): String {
        return "AOIManager: minX=${minX}, maxX=${maxX}, cntsX=${cntsX}, minY=${minY}, maxY=${maxY}, cntsY=${cntsY}"
    }

    // 打印信息
    public func print() {
        println("AOIManager: minX=${minX}, maxX=${maxX}, cntsX=${cntsX}, minY=${minY}, maxY=${maxY}, cntsY=${cntsY}")
        for (grid in grids) {
            println("	index：${grid[0]} grid: ${grid[1].toString()}")
        }
    }

    // 得到当前区域的关联所有格子
    public func getSurroundGridsByGid(gid: Int): ?ArrayList<Grid> {
        // 判断gid是否在AOIManager中
        if (!grids.contains(gid)) {
            return Option<ArrayList<Grid>>.None
        }
        // 根据gid得到当前格子对象
        let curGrid = grids.get(gid).getOrThrow()
        // 初始化一个集合，用来存放当前格子周围的格子集合
        let ret = ArrayList<Grid>()
        // 遍历当前格子周围的8个格子
        for (idx in -1..=1) {
            for (idy in -1..=1) {
                if (idx == 0 && idy == 0) {
                    continue
                }
                // 计算周围格子的格子ID
                let checkGid = gid + idx + idy * cntsX
				// println("	checkGid: ${checkGid}")
                // 判断周围格子ID是否在AOIManager中
                if (grids.contains(checkGid)) {
                    // 把周围的格子放到集合中
                    ret.append(grids.get(checkGid).getOrThrow())
                }
            }
        }

        return ret
    }
}

// 提供一个方法，让外界通过这个方法，得到指定坐标对应的格子对象
public func newAOIManager(minX: Int, maxX: Int, cntsX: Int, minY: Int, maxY: Int, cntsY: Int): AOIManager {
    return AOIManager(minX, maxX, cntsX, minY, maxY, cntsY)
}
