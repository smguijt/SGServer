import Foundation

struct UserBaseContext: Encodable {
    var title: String
    var paramId: String?
    var errorMessage: String?
    var successMessage: String?
    var settings: SGServerSettingsDTO
    var tabIndicator: String?
    var userPermissions: UserManagementRoleModelDTO?
    var userOrganizations: [UserManagementOrganizationModelDTO]?
    var userAccountData: UserManagementAccountModelDTO?
    var userDetail: UserManagementAddressModelDTO?
    var selectedUserId: String?
    var selectedUserPermissions: UserManagementRoleModelDTO?
}
