import Foundation
import Fluent
import Vapor

func getUserSettings(req: Request, userId: UUID) async throws -> SGServerSettingsDTO {
     
    var myUserSettingDTO: UserManagementUserSettingsDTO = UserManagementUserSettingsDTO(userId: userId)

     _ = try await UserManagementUserSettingsModel
            .query(on: req.db)
            .filter(\.$userId == userId)
            .all()
            .compactMap { setting in
                
                /* map ID */
                //myUserSettingDTO.ID = setting.id
                myUserSettingDTO.userId = userId
                
                /* ShowMessages*/
                if setting.key == UserManagementEnumSettings.ShowMessages.rawValue {
                    myUserSettingDTO.ShowMessages = Bool(setting.value.lowercased()) ?? false
                }

                /* ShowApps*/
                //if setting.key == UserManagementEnumSettings.ShowApps.rawValue {
                //    myUserSettingDTO.ShowApps = Bool(setting.value.lowercased()) ?? false
                //}
                
                /* ShowNotifications*/
                if setting.key == UserManagementEnumSettings.ShowNotifications.rawValue {
                    myUserSettingDTO.ShowNotifications = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ShowUpdates*/
                if setting.key == UserManagementEnumSettings.ShowUpdates.rawValue {
                    myUserSettingDTO.ShowUpdates = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ShowUseOAUTH02 */
                if setting.key == UserManagementEnumSettings.UseOAUTH02.rawValue {
                    myUserSettingDTO.UseOAUTH02 = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ClientId */
                if setting.key == UserManagementEnumSettings.ClientId.rawValue {
                    myUserSettingDTO.ClientId = String(setting.value)
                }
                
                /* ClientSecret */
                if setting.key == UserManagementEnumSettings.ClientSecret.rawValue {
                    myUserSettingDTO.ClientSecret = String(setting.value)
                }

                return myUserSettingDTO
            }

    
    let mySystemSettings: SGServerSettingsDTO = try await getSettings(req: req)
    let mySettingDTO: SGServerSettingsDTO = SGServerSettingsDTO(ShowToolbar: mySystemSettings.ShowToolbar,
                                                ShowMessages: myUserSettingDTO.ShowMessages,
                                                ShowApps: mySystemSettings.ShowApps,
                                                ShowNotifications: myUserSettingDTO.ShowNotifications,
                                                ShowUpdates: myUserSettingDTO.ShowUpdates,
                                                ShowUserBox: mySystemSettings.ShowUserBox,
                                                userId: myUserSettingDTO.userId,
                                                UseOAUTH02: myUserSettingDTO.UseOAUTH02,
                                                ClientId: myUserSettingDTO.ClientId,
                                                ClientSecret: myUserSettingDTO.ClientSecret)

    return mySettingDTO
 }

func getUserPermissionSettings(req: Request, userId: UUID) async throws -> UserManagementRoleModelDTO { 

       var myUserPermissionsDTO: UserManagementRoleModelDTO = UserManagementRoleModelDTO(userId: userId)
       _ = try await UserManagementRoleModel
                .query(on: req.db)
                .filter(\.$userId == userId)
                .all()
                .map { setting in
                    myUserPermissionsDTO.userId = userId
                    
                    if setting.role == UserManagementRoleEnum.admin.rawValue {
                        myUserPermissionsDTO.IsAdminUser = true
                    }
                    if setting.role == UserManagementRoleEnum.user.rawValue {
                        myUserPermissionsDTO.isUser = true
                    }
                    if setting.role == UserManagementRoleEnum.system.rawValue {
                        myUserPermissionsDTO.isSystemUser = true
                    }
                    if setting.role == UserManagementRoleEnum.api.rawValue {
                        myUserPermissionsDTO.isApiUser = true
                    }
                    if setting.role == UserManagementRoleEnum.superuser.rawValue {
                        myUserPermissionsDTO.isSuperUser = true
                        /* switch all values to active */
                        myUserPermissionsDTO.IsAdminUser = true
                        myUserPermissionsDTO.isUser = true
                        myUserPermissionsDTO.isSystemUser = true
                        myUserPermissionsDTO.isApiUser = true
                        myUserPermissionsDTO.isAllowedToUseEventManagementModule = true
                        myUserPermissionsDTO.isAllowedToUseTimeManagementModule = true
                        myUserPermissionsDTO.isAllowedToUseUserManagementModule = true
                        myUserPermissionsDTO.isAllowedToUseTaskManagementModule = true
                        return myUserPermissionsDTO
                    }
                    if setting.role == UserManagementRoleEnum.EventManagement.rawValue {
                        myUserPermissionsDTO.isAllowedToUseEventManagementModule = true
                    }
                    if setting.role == UserManagementRoleEnum.TimeManagement.rawValue {
                        myUserPermissionsDTO.isAllowedToUseTimeManagementModule = true
                    }
                    if setting.role == UserManagementRoleEnum.UserManagement.rawValue {
                        myUserPermissionsDTO.isAllowedToUseUserManagementModule = true
                    }
                    if setting.role == UserManagementRoleEnum.TaskManagement.rawValue {
                        myUserPermissionsDTO.isAllowedToUseTaskManagementModule = true
                    }
                    
                    return myUserPermissionsDTO
                }
    return myUserPermissionsDTO
}

func getUserOrganizations(req: Request, userId: UUID) async throws -> [UserManagementOrganizationModelDTO] {

    let organizations = try await UserManagementOrganizationModel
        .query(on: req.db)
        .join(UserManagementUserOrganizationsModel.self, on: \UserManagementOrganizationModel.$id == \UserManagementUserOrganizationsModel.$orgId, method: .left)
        .all()

    var transformedOrganizations: [UserManagementOrganizationModelDTO] = []
    for org: UserManagementOrganizationModel in organizations {
        
        let userOrganization: UserManagementUserOrganizationsModel = try org.joined(UserManagementUserOrganizationsModel.self)
        
        var isSelected: Bool = false
        if (userOrganization.userId == userId) {
            isSelected = true
        }

        let transformedOrganization:UserManagementOrganizationModelDTO = 
            UserManagementOrganizationModelDTO(code: org.code, description: org.description, selected: isSelected)
        
        var hasValue: Bool = false
        for (index, element) in transformedOrganizations.enumerated() {
            if element.code == org.code {
                transformedOrganizations[index].selected = isSelected
                hasValue = true
                break;
            }
        }

        if !hasValue {
            transformedOrganizations.append(transformedOrganization)
        }
    }

    return transformedOrganizations
}
        

func setUserPermissionSetting(req: Request, form: UserManagementDictDTO, role: UserManagementRoleEnum) async throws -> Response {
    
    let ret: Response = Response()
    let record: [UserManagementRoleModel] = try await UserManagementRoleModel
        .query(on: req.db)
        .filter(\.$role == role.rawValue)
        .filter(\.$userId == form.userId!)
        .all()

    if record.count > 0 {
        // record found so it has to be removed / disabled
        try await record.delete(on: req.db)

        ret.status = HTTPResponseStatus.accepted
        ret.body = Response.Body(string: "\(form.key!) key removed")
        req.logger.info("\(form.key!) key removed!")
    } else {
        // record not found so it must be created
        let newRecord: UserManagementRoleModel = UserManagementRoleModel(
                                                    role: role.rawValue, 
                                                    userId: form.userId!)
        try await newRecord.save(on: req.db)

        ret.status = HTTPResponseStatus.accepted
        ret.body = Response.Body(string: "\(form.key!) key added")
        req.logger.info("\(form.key!) key added!")
    }
    return ret
}