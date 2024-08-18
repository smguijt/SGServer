
import Foundation
import Fluent

final class UserManagementRoleModel: Model, @unchecked Sendable {
    static let schema = "UserManagementRoleModel"
    
    @ID(key: .id)
    var id: UUID?

    init() { }

    init(id: UUID? = nil) {
        self.id = id
    }

    init (id: UUID? = nil, role : UserManagementRoleEnum.RawValue, createdAt: Date?, updatedAt: Date?, userId: UUID?) {
        self.id = id
        self.role = role
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userId = userId
    }

    @Field(key: "role")
    var role : UserManagementRoleEnum.RawValue
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @OptionalField(key: "userId")
    var userId: UUID?

    
    func toDTO() -> UserManagementRoleModelDTO {
        .init(
            ID: self.id
        )
    }

}

