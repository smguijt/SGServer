
import Foundation
import Fluent

final class UserManagementUserOrganizationsModel: Model, @unchecked Sendable {
    static let schema = "UserManagementUserOrganizationsModel"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "orgId")
    var orgId : UUID?

    @Field(key: "userId")
    var userId: UUID?

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    init() { }

    init (id: UUID? = nil, orgId : UUID? = nil, userId: UUID? = nil) { 
        self.id = id
        self.orgId = orgId
        self.userId = userId
    }

}