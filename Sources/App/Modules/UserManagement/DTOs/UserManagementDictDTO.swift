import Fluent
import Vapor

struct UserManagementDictDTO: Content {
    
    let ID: UUID?
    let key: String?
    let value: String?
    let userId: UUID?
    
    init(ID: UUID?, key: String?, value: String?, userId: UUID?) {
        
        self.ID = ID
        self.key = key
        self.value = value
        self.userId = userId
    }
}
