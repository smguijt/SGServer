
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
    
    func toDTO() -> UserManagementRoleModelDTO {
        .init(
            ID: self.id
        )
    }

}

