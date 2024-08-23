import Foundation

struct UserBaseContext: Encodable {
    var title: String
    var paramId: String?
    var errorMessage: String?
    var settings: SGServerSettingsDTO
    var tabIndicator: String?
    var userPermissions: UserManagementRoleModelDTO?
}
