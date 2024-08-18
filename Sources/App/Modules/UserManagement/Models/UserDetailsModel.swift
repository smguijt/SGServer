
import Foundation
import Fluent

final class UserManagementDetailModel: Model, @unchecked Sendable {
    static let schema = "UserManagementDetailModel"
    
    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: "prefix")
    var prefix: String?

    @OptionalField(key: "firstname")
    var firstname: String?

    @OptionalField(key: "lastname")
    var lastname: String?

    @OptionalField(key: "postfix")
    var postfix: String?
    
    @OptionalField(key: "birthdate")
    var birthdate : Date?

    @OptionalField(key: "active")
    var active: Bool?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @OptionalField(key: "avatar")
    var avatar : URL?
    
    @OptionalField(key: "userId")
    var userId: UUID?

    init() { }

    init(id: UUID? = nil) {
        self.id = id
    }

    init (id: UUID? = nil, prefix : String? = nil, firstname: String? = nil, lastname: String? = nil, postfix: String? = nil, birthdate: Date? = nil, active: Bool? = false, createdAt: Date?, updatedAt: Date?, userId: UUID?) {
        self.id = id
        self.prefix = prefix
        self.firstname = firstname
        self.lastname = lastname
        self.postfix = postfix
        self.birthdate = birthdate
        self.active = active
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userId = userId
    }
    
    func toDTO() -> UserManagementDetailModelDTO {
        .init(
            ID: self.id
        )
    }

}

