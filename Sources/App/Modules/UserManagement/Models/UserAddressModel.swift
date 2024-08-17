
import Foundation
import Fluent

final class UserManagementAddressModel: Model, @unchecked Sendable {
    static let schema = "UserManagementAddressModel"
    
    @ID(key: .id)
    var id: UUID?

    init() { }

    init(id: UUID? = nil) {
        self.id = id
    }
    
    func toDTO() -> UserManagementAddressModelDTO {
        .init(
            ID: self.id
        )
    }

}

