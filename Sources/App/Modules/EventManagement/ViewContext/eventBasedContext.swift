import Foundation

struct EventBaseContext: Encodable {
    var title: String
    var paramId: String?
    var errorMessage: String?
    var successMessage: String?
    var settings: SGServerSettingsDTO
    var tabIndicator: String?
    var orgIndicator: String?
    var userPermissions: UserManagementRoleModelDTO?
    var userOrganizations: [UserManagementOrganizationModelDTO]?
}
