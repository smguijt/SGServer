import Fluent
import Vapor

struct UserManagementAccountModelDTO: Content {
    let ID: UUID?
    let email: String?
    let password: String?
    let updatedAt: Date?


    init(ID: UUID?, email: String?, password: String?, updatedAt: Date?) {
        self.ID = ID
        self.email = email
        self.password = password
        self.updatedAt = updatedAt
    }
}