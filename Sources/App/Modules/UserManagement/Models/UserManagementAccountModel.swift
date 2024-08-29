
import Foundation
import Fluent
import Vapor

final class UserManagementAccountModel: Model, @unchecked Sendable {
    static let schema = "UserManagementAccountModel"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "caption")
    var caption: String?

    @Field(key: "email")
    var email : String
    
    @Field(key: "password")
    var password: String
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, caption: String?, email : String, password: String) {
        self.id = id
        self.caption = caption
        self.email = email
        self.password = password
    }
    
    func toDTO() -> UserManagementAccountModelDTO {
        .init(
            ID: self.id,
            email: self.email,
            password: self.password,
            caption: self.caption
        )
    }

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }

}

