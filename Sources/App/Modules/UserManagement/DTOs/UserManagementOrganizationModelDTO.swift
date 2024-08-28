import Fluent
import Vapor

struct UserManagementOrganizationModelDTO: Content {
    
    
    let code: String?
    let description: String?
    var selected: Bool = false
    
    init(code: String?, description: String?, selected: Bool = false) {
        self.code = code
        self.description = description
        self.selected = selected
    }
}
