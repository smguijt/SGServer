import Fluent
import Vapor

struct queryParamsDTO: Content {

    let userId: UUID?
    let orgId: UUID?
    let subIndicator: String?
    let tabIndicator: String?
    let actionIndicator: String?
    let settings: SGServerSettingsDTO?
    let organizations: [UserManagementOrganizationModelDTO]?
    let permissions: UserManagementRoleModelDTO?
    let filter: String?

    init() {
        userId = nil
        orgId = nil
        subIndicator = nil
        tabIndicator = nil
        actionIndicator = nil
        settings = nil
        organizations = nil
        permissions = nil
        filter = nil
    }

    init(userId: UUID?, 
         orgId: UUID?,
         subIndicator: String?,
         tabIndicator: String?,
         actionIndicator: String?, 
         settings: SGServerSettingsDTO?,  
         organizations: [UserManagementOrganizationModelDTO]?, 
         permissions: UserManagementRoleModelDTO?,
         filter: String?) {
            self.userId = userId
            self.orgId = orgId
            self.subIndicator = subIndicator
            self.tabIndicator = tabIndicator
            self.actionIndicator = actionIndicator
            self.settings = settings
            self.organizations = organizations
            self.permissions = permissions
            self.filter = filter
    }
}
