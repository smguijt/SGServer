
import Foundation
import Fluent

final class UserManagementAddressModel: Model, @unchecked Sendable {
    static let schema = "UserManagementAddressModel"
    
    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: "steet")
    var street : String?
    
    @OptionalField(key: "housno")
    var housno: String?

    @OptionalField(key: "postalcode")
    var postalcode: String?

    @OptionalField(key: "city")
    var city: String?

    @OptionalField(key: "country")
    var country: String?

    @OptionalField(key: "telephone")
    var telephone: String?

    @OptionalField(key: "mobile")
    var mobile: String?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @OptionalField(key: "userId")
    var userId: UUID?


    init() { }

    init(id: UUID? = nil) {
        self.id = id
    }

    init (id: UUID? = nil, street : String? = nil, housno: String? = nil, postalcode: String? = nil, city: String? = nil, country: String? = nil, telephone: String? = nil, mobile: String? = nil, 
          //createdAt: Date?, updatedAt: Date?, 
          userId: UUID?) {
        self.id = id
        self.street = street
        self.housno = housno
        self.postalcode = postalcode
        self.city = city
        self.country = country
        self.telephone = telephone
        self.mobile = mobile
        //self.createdAt = createdAt
        //self.updatedAt = updatedAt
        self.userId = userId
    }
    
    func toDTO() -> UserManagementAddressModelDTO {
        .init(
            ID: self.id,
            street: self.street, 
            housno: self.housno, 
            postalcode: self.postalcode, 
            city: self.city, 
            country: self.country, 
            telephone: self.telephone,
            mobile: self.mobile
        )
    }

}

