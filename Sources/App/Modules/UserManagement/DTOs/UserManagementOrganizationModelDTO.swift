import Fluent
import Vapor

struct UserManagementOrganizationModelDTO: Content {
    
    
    let code: String?
    let description: String?
    let selected: Bool? 
    
    init(code: String?, description: String?, selected: Bool? = false) {
        
        self.code = code
        self.description = description
        self.selected = selected
    }
}
