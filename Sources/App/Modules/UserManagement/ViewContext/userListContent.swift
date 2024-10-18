import Foundation

struct UserListContext: Encodable {
    var title: String
    var paramId: String?
    var errorMessage: String?
    var successMessage: String?
    var settings: SGServerSettingsDTO
    var tabIndicator: String?
    var orgIndicator: String?
    var actionIndicator: String?
    var userPermissions: UserManagementRoleModelDTO?
    var userList: [UserManagementUserDTO]?
    var selectedUserId: String?
    var userOrganizations: [UserManagementOrganizationModelDTO]?
}
