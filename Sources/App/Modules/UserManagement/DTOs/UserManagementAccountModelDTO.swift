import Fluent
import Vapor

struct UserManagementAccountModelDTO: Content {
    let ID: UUID?
    let email: String?
    let password: String?
    let caption: String?
    
    init(ID: UUID?, 
         email: String?, 
         password: String?,
         caption: String?) {
            
        self.ID = ID
        self.email = email
        self.password = password
        self.caption = caption
    }
}