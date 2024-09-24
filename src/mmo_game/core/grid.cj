package cjweave.mmo_game.core

import std.collection.*

public class Grid {
    // 格子id
    public var gid: Int = 0
    // 格子的左边边界坐标
    public var minX: Int = 0
    // 格子的右边边界坐标
    public var maxX: Int = 0
    // 格子的上边边界坐标
    public var minY: Int = 0
    // 格子的下边边界坐标
    public var maxY: Int = 0
    // 当前格子内的玩家或者物体成员的ID集合
    public var playerIds: HashMap<Int, Bool> = HashMap<Int, Bool>()

    // 格式信息
    public func toString(): String {
        return "Grid(gid=${gid}, minX=${minX}, maxX=${maxX}, minY=${minY}, maxY=${maxY}, playerIds=${playerIds})"
    }

    // 初始化一个格子
    public Grid(gid: Int, minX: Int, maxX: Int, minY: Int, maxY: Int) {
        this.gid = gid
        this.minX = minX
        this.maxX = maxX
        this.minY = minY
        this.maxY = maxY
    }

    // 给格子添加一个玩家
    public func add(playerId: Int) {
        playerIds.put(playerId, true)
    }

    // 移除格子中的一个玩家
    public func remove(playerId: Int) {
        playerIds.remove(playerId)
    }

    // 通过格子ID获取所有玩家或者物体成员
    public func getPlayerIds(): Array<Int> {
        var ids2: Array<Int> = Array<Int>()
        for (id in playerIds) {
            ids2.fill(id[0])
        }
        return ids2
    }
}

// 创建一个格子
public func newGrid(gid: Int, minX: Int, maxX: Int, minY: Int, maxY: Int): Grid {
    return Grid(gid, minX, maxX, minY, maxY)
}
