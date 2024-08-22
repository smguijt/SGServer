import Foundation
import Vapor

public struct UserManagementUserLoginResponseDTO: Codable {
    public var error: Bool?
    public var reason: String? = nil
    public var token: String? = nil
    public var userId: UUID?
    public var orgId: String? = nil

    public init(error: Bool, reason: String?, token: String?, userId: UUID?, orgId: String?) {
        self.error = error
        self.reason = reason
        self.token = token
        self.userId = userId
        self.orgId = orgId
    }

    public init() {
        self.error = false
    }
}
