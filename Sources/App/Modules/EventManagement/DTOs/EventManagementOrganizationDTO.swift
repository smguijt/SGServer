import Fluent
import Vapor

struct EventManagementOrganizationDTO: Content {

    let organization: String?
    
    init(organization: String?) {
        self.organization = organization
    }

    init() {
        self.organization = nil
    }
}