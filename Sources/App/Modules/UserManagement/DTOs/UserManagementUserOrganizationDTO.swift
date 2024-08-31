import Fluent
import Vapor

struct UserManagementUserOrganizationDTO: Content { 
    let organizations: [String]?

    init(organizations: [String]? = [])
    {
        self.organizations = organizations
    }
}