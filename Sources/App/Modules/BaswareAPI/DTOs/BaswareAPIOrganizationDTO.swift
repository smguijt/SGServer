import Fluent
import Vapor

struct BaswareAPIOrganizationDTO: Content {

    let organization: String?
    
    init(organization: String?) {
        self.organization = organization
    }

    init() {
        self.organization = nil
    }
}