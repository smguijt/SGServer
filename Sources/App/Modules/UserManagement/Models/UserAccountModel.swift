
import Foundation
import Fluent

final class UserManagementAccountModel: Model, @unchecked Sendable {
    static let schema = "UserManagementAccountModel"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email : String
    
    @Field(key: "password")
    var password: String
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, email : String, password: String, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.email = email
        self.password = password
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func toDTO() -> UserManagementAccountModelDTO {
        .init(
            ID: self.id,
            email: self.email,
            password: self.password,
            updatedAt: self.updatedAt
        )
    }

}

