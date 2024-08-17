import Fluent
import Vapor

struct UserManagementAddressModelDTO: Content {
    let ID: UUID?

    init(ID: UUID?) {
        self.ID = ID
    }
}