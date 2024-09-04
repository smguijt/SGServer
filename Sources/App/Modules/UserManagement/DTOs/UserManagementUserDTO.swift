import Fluent
import Vapor

struct UserManagementUserDTO: Content {
    let Id: String?
    let caption: String?

    
    
    init(ID: UUID?, 
         caption: String?) {
            
        self.Id = ID?.uuidString
        self.caption = caption
    }
}