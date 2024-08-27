import Fluent
import Vapor

struct UserManagementOrganizationModelDTO: Content {
    
    
    let code: String?
    let description: String?

    
    init(code: String?, description: String?) {
        

        self.code = code
        self.description = description
    }
}
