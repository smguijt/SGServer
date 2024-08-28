import Fluent
import Vapor

struct UserManagementAccountModelDTO: Content {
    let ID: UUID?
    let email: String?
    let password: String?
    let updatedAt: Date?
    let orgId: String? 
    
    /* TODO UserManagementUserOrganizations .... */

    init(ID: UUID?, email: String?, password: String?, orgId: String?, updatedAt: Date?) {
        self.ID = ID
        self.email = email
        self.password = password
        self.orgId = orgId
        self.updatedAt = updatedAt
    }
}