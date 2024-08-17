import Fluent
import Vapor

struct UserManagementDetailModelDTO: Content {
    let ID: UUID?

    init(ID: UUID?) {
        self.ID = ID
    }
}