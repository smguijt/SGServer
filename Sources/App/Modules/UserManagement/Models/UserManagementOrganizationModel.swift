
import Foundation
import Fluent
import Vapor

final class UserManagementOrganizationModel: Model, @unchecked Sendable {
    static let schema = "UserManagementOrganizationModel"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "code")
    var code : String?

    @Field(key: "description")
    var description: String?

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    init() { }

    init (id: UUID? = nil, code : String? = nil, description: String? = nil) { 
        self.id = id
        self.code = code
        self.description = description
    }

    func toDTO() -> UserManagementOrganizationModelDTO {
        .init(
            code: self.code,
            description: self.description
        )
    }
}