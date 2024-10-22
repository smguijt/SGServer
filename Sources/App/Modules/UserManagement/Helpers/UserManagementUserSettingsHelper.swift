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

                 /* SidebarToggleState */
                if setting.key == UserManagementEnumSettings.SidebarToggleState.rawValue {
                    myUserSettingDTO.SidebarToggleState = Bool(setting.value.lowercased()) ?? false
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
                                                ClientSecret: myUserSettingDTO.ClientSecret,
                                                SidebarToggleState: myUserSettingDTO.SidebarToggleState)

    return mySettingDTO
 }

func getUserPermissionSettings(req: Request, userId: UUID, selectedUserId: UUID?) async throws -> UserManagementRoleModelDTO {

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

    let myUserAccount = try await UserManagementAccountModel
            .query(on: req.db)
            .filter(\.$id == userId)
            .first()
    
    if myUserAccount != nil {
        myUserPermissionsDTO.caption = myUserAccount?.caption
    }
    
    return myUserPermissionsDTO
}

func getUserOrganizations(req: Request, userId: UUID, filterByUser: Bool = false) async throws -> [UserManagementOrganizationModelDTO] {

    let organizations: [UserManagementOrganizationModel] = try await UserManagementOrganizationModel
        .query(on: req.db)
        //.join(UserManagementUserOrganizationsModel.self, on: \UserManagementOrganizationModel.$id == \UserManagementUserOrganizationsModel.$orgId, method: .left)
        .all()

    var transformedOrganizations: [UserManagementOrganizationModelDTO] = []
    for org: UserManagementOrganizationModel in organizations {

        req.logger.info("Organization Code: \(org.code!)")
        req.logger.info("Organization Id: \(org.id!)")
        req.logger.info("User Id: \(userId)")
        
        //let userOrganization: UserManagementUserOrganizationsModel = try org.joined(UserManagementUserOrganizationsModel.self)
        let userOrganizations: [UserManagementUserOrganizationsModel] = 
            try await UserManagementUserOrganizationsModel
                .query(on: req.db)
                .filter(\.$userId == userId)
                .filter(\.$orgId == org.id)
                .all()

        var bHasValue: Bool = false
        let isSelected: Bool = userOrganizations.count > 0
       
        let transformedOrganization:UserManagementOrganizationModelDTO = 
            UserManagementOrganizationModelDTO(code: org.code, description: org.description, selected: isSelected)
        req.logger.info("transformedOrganization: \(transformedOrganization)")
        
        for element in transformedOrganizations {
            if element.code == org.code {
                req.logger.info("item to transformedOrganization already exists!")
                bHasValue = true
                break;
            }
        }

        if !bHasValue {
            req.logger.info("add item to transformedOrganization")
            if !filterByUser {
                transformedOrganizations.append(transformedOrganization)
            } else {
                if transformedOrganization.selected {
                    transformedOrganizations.append(transformedOrganization)
                }
            }
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

func getUserAddressData(req: Request, userId: UUID) async throws -> UserManagementAddressModelDTO {

    guard let addressInfo = try await UserManagementAddressModel
        .query(on: req.db)
        .filter(\.$userId == userId)
        .first()
    else {
        return UserManagementAddressModelDTO(
            ID: nil,
            street: "", 
            housno: "", 
            postalcode: "", 
            city: "", 
            country: "", 
            telephone: "",
            mobile: "")
    }
        
    return addressInfo.toDTO()
}

func setUserAddressData(req: Request, form: UserManagementAddressModelDTO, userId: UUID) async throws -> UserManagementAddressModelDTO {

    guard let addressInfo: UserManagementAddressModel = try await UserManagementAddressModel
        .query(on: req.db)
        .filter(\.$userId == userId)
        .first()
    else {
        /* new record */
        let newAddress: UserManagementAddressModel = 
            UserManagementAddressModel(
                street: form.street, 
                housno: form.housno, 
                postalcode: form.postalcode, 
                city: form.city, 
                country: form.country, 
                telephone: form.telephone,
                mobile: form.mobile,
                userId: userId
            )
        _ = try await newAddress.create(on: req.db)    
        return newAddress.toDTO()    
    }

    /* update record */
    if (addressInfo.street != form.street) { addressInfo.street = form.street }
    if (addressInfo.housno != form.housno) { addressInfo.housno = form.housno }
    if (addressInfo.postalcode != form.postalcode) { addressInfo.postalcode = form.postalcode }
    if (addressInfo.country != form.country) { addressInfo.country = form.country }
    if (addressInfo.city != form.city) { addressInfo.city = form.city }
    if (addressInfo.telephone != form.telephone) { addressInfo.telephone = form.telephone }
    if (addressInfo.mobile != form.mobile) { addressInfo.mobile = form.mobile }
    //addressInfo.userId = userId

    /* save changes */
    try await addressInfo.save(on: req.db)

    /* return */
    return addressInfo.toDTO()
}

func getUserAccountInfo(req: Request, userId: UUID) async throws -> UserManagementAccountModelDTO {

    do {
        let accountInfo: UserManagementAccountModel = try await UserManagementAccountModel
            .query(on: req.db)
            .filter(\.$id == userId)
            .first() ?? UserManagementAccountModel()

        return accountInfo.toDTO()
    } catch {
        return UserManagementAccountModelDTO()
    }
}

func setUserAccountInfo(req: Request, form: UserManagementAccountModelDTO, userId: UUID, actionIndicator: String?, org: String?) async throws -> Bool {
    
    /* TO DO: On Create add userOrganization from ORG parameter */

    do {
        if actionIndicator != "add" {
            let accountInfo: UserManagementAccountModel = try await UserManagementAccountModel
                .query(on: req.db)
                .filter(\.$id == userId)
                .first()!
                
            if (accountInfo.caption != form.caption) { accountInfo.caption = form.caption }
            if (accountInfo.email != form.email) { accountInfo.email = form.email! }
            
            try await accountInfo.save(on: req.db)
        } else {
            let newRecord: UserManagementAccountModel = UserManagementAccountModel(id: userId, caption: form.caption, email: form.email!, password: try Bcrypt.hash(form.password_hash!))
            try await newRecord.create(on: req.db)
        }
    } catch {
        return false
    }
    return true
}



func setUserOrganizationData(req: Request, form: UserManagementUserOrganizationDTO, userId: UUID) async throws -> Bool {

    var existingOrganizations: [UserManagementUserOrganizationsModel]?
    do {
        existingOrganizations = try await UserManagementUserOrganizationsModel
            .query(on: req.db)
            .join(UserManagementOrganizationModel.self, on: \UserManagementOrganizationModel.$id == \UserManagementUserOrganizationsModel.$orgId, method: .inner)
            .filter(\.$userId == userId)
            .all()
    }
    catch {
        return false
    }

    /* process */
    for existingOrg: UserManagementUserOrganizationsModel in existingOrganizations! {
        //let userOrganization: UserManagementOrganizationModel = try existingOrg.joined(UserManagementOrganizationModel.self)
        try await existingOrg.delete(on: req.db)
    }
    
    var OrganizationsList: [UserManagementOrganizationModel]?
    for formItem in form.organizations ?? [] {
        do {
            OrganizationsList = try await UserManagementOrganizationModel.query(on: req.db).all()
        } catch {
            /* could not retrieve any records to nothing to update */
            return false
        }
            
        for orgItem in OrganizationsList ?? [] {
            if orgItem.code == formItem {
                /* item found so add */
                let newRecord: UserManagementUserOrganizationsModel = UserManagementUserOrganizationsModel(orgId: orgItem.id, userId: userId)
                try await newRecord.create(on: req.db)
            } 
        }
    }
    return true
}

func getUserList(req: Request, userId: UUID, org: String?) async throws -> [UserManagementUserDTO] {
    
    /* TO DO: FILTER BY ORGANIZATION */

    let list = try await UserManagementAccountModel
        .query(on: req.db)
        .all()
        .map { item in 
           return UserManagementUserDTO(ID: item.id, 
                                        caption: item.caption)

        }
    return list
}
