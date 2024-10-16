import Fluent
import Vapor
import Foundation

final class  UserManagementAddressModelDTO: Content {

    static let schema = "UserManagementAddress"

    let ID: UUID?
    let street : String?
    let housno: String?
    let postalcode: String?
    let city: String?
    let country: String?
    let telephone: String?
    let mobile: String?
    
    init(
        ID: UUID?, 
        street: String?,
        housno: String?,
        postalcode: String?,
        city: String?,
        country: String?,
        telephone: String?,
        mobile: String?) {
            
        self.ID = ID
        self.street = street
        self.housno = housno
        self.postalcode = postalcode
        self.city = city
        self.country = country
        self.telephone = telephone
        self.mobile = mobile
    }
    
    init() {
        self.ID = nil
        self.street = nil
        self.housno = nil
        self.postalcode = nil
        self.city = nil
        self.country = nil
        self.telephone = nil
        self.mobile = nil
    }
}
