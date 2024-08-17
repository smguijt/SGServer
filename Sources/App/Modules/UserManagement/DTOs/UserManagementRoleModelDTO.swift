import Fluent
import Vapor

struct UserManagementRoleModelDTO: Content {
    let ID: UUID?

    init(ID: UUID?) {
        self.ID = ID
    }
}