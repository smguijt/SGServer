import Fluent
import Vapor

struct UserManagementRoleModelDTO: Content {
    var userId: UUID?
    var caption: String?
    var IsAdminUser: Bool
    var isUser: Bool = true
    var isSuperUser: Bool
    var isSystemUser: Bool
    var isApiUser: Bool
    var isAllowedToUseUserManagementModule: Bool
    var isAllowedToUseTimeManagementModule: Bool
    var isAllowedToUseEventManagementModule: Bool
    var isAllowedToUseTaskManagementModule: Bool

    init(userId: UUID?,
         isAdminUser: Bool = false,
         isUser: Bool = true,
         isSuperUser: Bool = false, 
         isSystemUser: Bool = false,
         isApiUser: Bool = false,
         isAllowedToUseUserManagementModule: Bool = false,
         isAllowedToUseTimeManagementModule: Bool = false,
         isAllowedToUseEventManagementModule: Bool = false,
         isAllowedToUseTaskManagementModule: Bool = false,
         caption: String? = nil)
    {
        self.userId = userId!
        self.IsAdminUser = isAdminUser
        self.isUser = isUser
        self.isSuperUser = isSuperUser
        self.isSystemUser = isSystemUser
        self.isApiUser = isApiUser
        self.isAllowedToUseUserManagementModule = isAllowedToUseUserManagementModule
        self.isAllowedToUseTimeManagementModule = isAllowedToUseTimeManagementModule
        self.isAllowedToUseEventManagementModule = isAllowedToUseEventManagementModule
        self.isAllowedToUseTaskManagementModule = isAllowedToUseTaskManagementModule
        self.caption = caption

    }
    
    init() {
        self.userId = nil
        self.IsAdminUser = false
        self.isUser = false
        self.isSuperUser = false
        self.isSystemUser = false
        self.isApiUser = false
        self.isAllowedToUseUserManagementModule = false
        self.isAllowedToUseTimeManagementModule = false
        self.isAllowedToUseEventManagementModule = false
        self.isAllowedToUseTaskManagementModule = false
        self.caption = nil
    }


}
