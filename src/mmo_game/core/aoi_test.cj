package cjweave.mmo_game.core

import std.unittest.*
import std.unittest.testmacro.*

@Test
class AOIManagerTests {
    @TestCase
    func testAOI() {
        let aoiManager = newAOIManager(0, 250, 5, 0, 250, 5)
        aoiManager.print()

        let a17 = aoiManager.getSurroundGridsByGid(17)
        println("a17: ")
        if (!a17.isNone()) {
            for (grid in a17.getOrThrow()) {
                println("	${grid.toString()}")
            }
        }
        let a10 = aoiManager.getSurroundGridsByGid(10)
        println("a10: ")
        if (!a10.isNone()) {
            for (grid in a10.getOrThrow()) {
                println("	${grid.toString()}")
            }
        }
        let a0 = aoiManager.getSurroundGridsByGid(0)
        println("a0: ")
        if (!a0.isNone()) {
            for (grid in a0.getOrThrow()) {
                println("	${grid.toString()}")
            }
        }
        let a3 = aoiManager.getSurroundGridsByGid(3)
        println("a3: ")
        if (!a3.isNone()) {
            for (grid in a3.getOrThrow()) {
                println("	${grid.toString()}")
            }
        }
		let a24 = aoiManager.getSurroundGridsByGid(24)
        println("a24: ")
        if (!a24.isNone()) {
            for (grid in a24.getOrThrow()) {
                println("	${grid.toString()}")
            }
        }
    }
}
