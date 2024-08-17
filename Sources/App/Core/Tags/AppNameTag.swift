import Foundation
import Leaf
import Vapor

struct AppNameTag: LeafTag {
    func render(_ ctx: LeafContext) throws -> LeafData {
        return LeafData.string("Backend Service")
    }
}


