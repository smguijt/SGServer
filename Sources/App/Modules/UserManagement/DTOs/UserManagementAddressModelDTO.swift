import Fluent
import Vapor
import Foundation

final class  UserManagementAddressModelDTO: Content {

    static let schema = "UserManagementAddress"

    let ID: UUID?
    
   

    init(ID: UUID?) {
        self.ID = ID
    }
}