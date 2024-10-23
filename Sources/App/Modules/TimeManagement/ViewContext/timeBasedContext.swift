import Foundation

struct TimeBaseContext: Encodable {
    var title: String?
    var paramId: String?
    var errorMessage: String?
    var successMessage: String?
    var settings: SGServerSettingsDTO?
    var orgIndicator: String?
    var tabIndicator: String?
    var actionIndicator: String?
    var userPermissions: UserManagementRoleModelDTO?
    var userOrganizations: [UserManagementOrganizationModelDTO]?
    var filter: String?
}
