
import Foundation
import Fluent

final class UserManagementDetailModel: Model, @unchecked Sendable {
    static let schema = "UserManagementDetailModel"
    
    @ID(key: .id)
    var id: UUID?

    init() { }

    init(id: UUID? = nil) {
        self.id = id
    }
    
    func toDTO() -> UserManagementDetailModelDTO {
        .init(
            ID: self.id
        )
    }

}

