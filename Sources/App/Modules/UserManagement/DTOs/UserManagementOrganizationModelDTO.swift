import Fluent
import Vapor

struct UserManagementOrganizationModelDTO: Content {
    
    let ID: UUID?
    let code: String?
    let description: String?

    
    init(ID: UUID?, code: String?, description: String?) {
        
        self.ID = ID
        self.code = code
        self.description = description
    }
}
