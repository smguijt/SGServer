import Foundation

struct TaskBaseContext: Encodable {
    var title: String
    var paramId: String?
    var errorMessage: String?
    var successMessage: String?
    var settings: SGServerSettingsDTO
    var tabIndicator: String?
    var userPermissions: UserManagementRoleModelDTO?
    var userOrganizations: [UserManagementOrganizationModelDTO]?
}
