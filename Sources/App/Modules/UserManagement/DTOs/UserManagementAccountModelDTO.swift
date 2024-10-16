import Fluent
import Vapor

struct UserManagementAccountModelDTO: Content {
    let ID: UUID?
    let email: String?
    let password: String?
    let caption: String?
    let password_hash: String?
    
    init(ID: UUID?, 
         email: String?, 
         password: String?,
         caption: String?,
         password_hash: String?) {
            
        self.ID = ID
        self.email = email
        self.password = password
        self.caption = caption
        self.password_hash = password_hash
    }
    
    init() {
        self.ID = nil
        self.email = nil
        self.password = nil
        self.caption = nil
        self.password_hash = nil
    }
}
