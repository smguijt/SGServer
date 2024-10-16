import Fluent
import Vapor
import Leaf

struct UserManagementUserController: RouteCollection {
    
    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view")
            .grouped("module")
            .grouped("usermanagement")
            .grouped(AuthenticationSessionMiddleware())
        
        pg.get("", use: self.renderUserList)
        pg.get("general", use: self.renderUserList)
        pg.get("address", use: self.renderUserManagementScreens)
        pg.get("account", use: self.renderUserManagementScreens)
        pg.get("permissions", use: self.renderUserManagementScreens)
        pg.get("settings", use: self.renderUserManagementScreens)
        
        pg.post("details", use: self.renderUserManagementScreens)
        //pg.delete("details", use: self.renderUserManagementScreens)
        
        pg.post("address", use: self.updateUserManagementAddressFields)
        pg.post("organizations", use: self.updateUserManagementOrganizations)
        pg.post("permissions", use: self.updateUserManagementPermissions)
        pg.post("settings", use: self.updateUserManagementSetting)
        pg.post("account", use: self.updateUserManagementAccountFields)
    }
    
    @Sendable
    func renderUserList(req: Request) async throws -> View {
        
        req.logger.info("calling UserManagement.userList")
        
        /* get login user */
        let userIdString = req.session.data["sgsoftware_system_user"] ?? ""
        let userId: UUID? = UUID(uuidString: userIdString) ?? nil
        req.logger.info("UserManagement.userList userId: \(userIdString)")

        /* get selected action */
        var selectedAction = try? req.query.get(String.self, at: "action")
        if (selectedAction == nil) { selectedAction = "edit" }
        req.logger.info("UserManagement.userList selectedAction: \(String(describing:selectedAction))")

        /* get selected user */
        var selectedUserIdString = try? req.query.get(String.self, at: "selectedUserId")
        req.logger.info("UserManagement.userList selectedUserIdString parsed value : \(String(describing:selectedUserIdString))")

        if (selectedUserIdString == nil && selectedAction == "edit") { selectedUserIdString = userIdString }
        if (selectedUserIdString == nil && selectedAction == "add") { selectedUserIdString = UUID.generateRandom().uuidString }
        req.logger.info("UserManagement.userList selectedUserIdString updated value : \(String(describing:selectedUserIdString))")
        let selectedUserId = UUID(uuidString: selectedUserIdString ?? "") ?? nil
        req.logger.info("UserManagement.userList selectedUserIdString: \(String(describing:selectedUserIdString))")
        
        
        
        /* retrieve tabSettings */
        var tabIndicator: String? = try? req.query.get(String.self, at: "tabid")
        if (tabIndicator == nil) {
            tabIndicator = "general"
        }
        
        /* retrieve settings */
        var mySettingsDTO = try await getSettings(req: req)
        
        /* if logged in, retrieve user settings */
        if req.session.data["sgsoftware_system_user"] ?? "n/a" != "n/a" {
            let userId = UUID(req.session.data["sgsoftware_system_user"] ?? "")
            mySettingsDTO = try await getUserSettings(req: req, userId: userId!)
            mySettingsDTO.ShowUserBox = true
            mySettingsDTO.ShowToolbar = true
        }
        
        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO =
        try await getUserPermissionSettings(req: req, userId: userId!, selectedUserId: selectedUserId)
        
        /* get userlist */
        let userList = try await getUserList(req: req, userId: userId!)
        
        return try await req.view.render("UserManagement",
                                         UserListContext(title: "SGServer",
                                                         settings: mySettingsDTO,
                                                         tabIndicator: tabIndicator,
                                                         actionIndicator: selectedAction,
                                                         userPermissions: myUserPermissionsDTO,
                                                         userList: userList,
                                                         selectedUserId: selectedUserIdString))
    }
    
    @Sendable
    func renderUserManagementScreens(_ req: Request) async throws -> View {
        
        /* get login user */
        let userIdString = req.session.data["sgsoftware_system_user"] ?? ""
        let userId : UUID? = UUID(uuidString: userIdString) ?? nil
        req.logger.info("UserManagement.userList userId: \(userIdString)")

        /* get selected action */
        var selectedAction = try? req.query.get(String.self, at: "action")
        if (selectedAction == nil) { selectedAction = "edit" }
        req.logger.info("UserManagement.userList selectedAction: \(String(describing:selectedAction))")
        
        /* get selected user */
        var selectedUserIdString = try? req.query.get(String.self, at: "selectedUserId")
        req.logger.info("UserManagement.userList selectedUserIdString parsed value : \(String(describing:selectedUserIdString))")

        if ((selectedUserIdString == nil || selectedUserIdString == "NONE") && selectedAction == "edit") {
            selectedUserIdString = userIdString
            req.logger.info("UserManagement.userList selectedUserIdString updated (edit) value : \(String(describing:selectedUserIdString))")
        }
        if ((selectedUserIdString == nil || selectedUserIdString == "NONE") && selectedAction == "add") {
            selectedUserIdString = UUID.generateRandom().uuidString
            req.logger.info("UserManagement.userList selectedUserIdString updated (add) value : \(String(describing:selectedUserIdString))")
        }
        //req.logger.info("UserManagement.userList selectedUserIdString updated value : \(String(describing:selectedUserIdString))")
        let selectedUserId = UUID(uuidString: selectedUserIdString ?? "") ?? nil
        req.logger.info("UserManagement.userList selectedUserIdString: \(String(describing:selectedUserIdString))")
        
        /* retrieve tabSettings */
        var tabIndicator: String? = try? req.query.get(String.self, at: "tabid")
        if (tabIndicator == nil) {
            tabIndicator = "general"
        }
        
        /* set selectedAccordionPanel */
        var selectedAccordionPanel: String? = "Address Details"
        if selectedAction == "add" {
            selectedAccordionPanel = "Account Details";
        }
        
        /* retrieve settings */
        var mySettingsDTO = try await getSettings(req: req)
        
        /* if logged in, retrieve user settings */
        if selectedAction != "add" {
            if req.session.data["sgsoftware_system_user"] ?? "n/a" != "n/a" {
                _ = UUID(req.session.data["sgsoftware_system_user"] ?? "")
                //if (selectedUserId == nil) { selectedUserId = UUID.generateRandom() }
                mySettingsDTO = try await getUserSettings(req: req, userId: selectedUserId!)
                mySettingsDTO.ShowUserBox = true
                mySettingsDTO.ShowToolbar = true
            }
        }
        
        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO =
        try await getUserPermissionSettings(req: req, userId: userId!, selectedUserId: userId)
        /* +++++++ */
        
        /* retrieve user organizations */
        var myOrganizations: [UserManagementOrganizationModelDTO] = []
        if selectedAction != "add" {
            myOrganizations = try await getUserOrganizations(req: req,  userId: selectedUserId!)
            req.logger.info("userProfile.Organizations retrieved: \(myOrganizations)")
        }
        
        /* retrieve user address info */
        var myAddressInfo: UserManagementAddressModelDTO = UserManagementAddressModelDTO()
        if selectedAction != "add" {
            myAddressInfo = try await getUserAddressData(req: req, userId: selectedUserId!)
        }
        
        /* retrieve account info */
        var myAccountInfo: UserManagementAccountModelDTO = UserManagementAccountModelDTO()
        if selectedAction != "add" {
            myAccountInfo = try await getUserAccountInfo(req: req, userId: selectedUserId!)
        }
        
        /* retrieve user permissions for selected user */
        var mySelectedUserPermissionsDTO: UserManagementRoleModelDTO = UserManagementRoleModelDTO()
        if selectedAction != "add" {
            mySelectedUserPermissionsDTO =
            try await getUserPermissionSettings(req: req, userId: selectedUserId!, selectedUserId: selectedUserId)
        }
        
        return try await req.view.render("UserManagement",
                                         UserBaseContext(title: "SGServer",
                                                         settings: mySettingsDTO,
                                                         tabIndicator: tabIndicator,
                                                         actionIndicator: selectedAction,
                                                         userPermissions: myUserPermissionsDTO,
                                                         userOrganizations: myOrganizations,
                                                         userAccountData: myAccountInfo,
                                                         userDetail: myAddressInfo,
                                                         selectedUserId: selectedUserIdString,
                                                         selectedUserPermissions: mySelectedUserPermissionsDTO,
                                                         selectedAccordionPanel: selectedAccordionPanel))
    }
    
    
    
    @Sendable
    func updateUserManagementPermissions(_ req: Request) async throws -> Response {
        
        req.logger.notice("calling UserManagementUserPermissions.updateUserProfilePermissions POST")
        req.logger.debug("incomming request: \(req.body)")
        
        /* determine user */
        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? UUID()
        req.logger.info("calling UserManagementUserPermissions.updateUserProfilePermissions.id POST: \(userId)")
        
        /* decode body */
        let body: UserManagementDictDTO = try req.content.decode(UserManagementDictDTO.self)
        
        /* capture key */
        var ret: Response = Response()
        var bFound: Bool = false
        switch body.key {
        case "isAdminUser":
            ret = try await setUserPermissionSetting(req: req, form: body, role: UserManagementRoleEnum.admin)
            bFound = true
            break;
        case "isUser":
            ret = try await setUserPermissionSetting(req: req, form: body, role: UserManagementRoleEnum.user)
            bFound = true
            break;
        case "isApiUser":
            ret = try await setUserPermissionSetting(req: req, form: body, role: UserManagementRoleEnum.api)
            bFound = true
            break;
        case "isSuperUser":
            ret = try await setUserPermissionSetting(req: req, form: body, role: UserManagementRoleEnum.superuser)
            bFound = true
            break;
        case "isSystemUser":
            ret = try await setUserPermissionSetting(req: req, form: body, role: UserManagementRoleEnum.system)
            bFound = true
            break;
        case "isAllowedToUseUserManagementModule":
            ret = try await setUserPermissionSetting(req: req, form: body, role: UserManagementRoleEnum.UserManagement)
            bFound = true
            break;
        case "isAllowedToUseTimeManagementModule":
            ret = try await setUserPermissionSetting(req: req, form: body, role: UserManagementRoleEnum.TimeManagement)
            bFound = true
            break;
        case "isAllowedToUseEventManagementModule":
            ret = try await setUserPermissionSetting(req: req, form: body, role: UserManagementRoleEnum.EventManagement)
            bFound = true
            break;
        case "isAllowedToUseTaskManagementModule":
            ret = try await setUserPermissionSetting(req: req, form: body, role: UserManagementRoleEnum.TaskManagement)
            bFound = true
            break;
        default:
            bFound = false;
            break;
        }
        
        if !bFound {
            ret.status = HTTPResponseStatus.badRequest
            ret.body = Response.Body(string: "\(body.key!) is not a valid key!")
            req.logger.info("\(body.key!) is not a valid key!")
        }
        
        return ret
    }
    
    @Sendable
    func updateUserManagementSetting(_ req: Request) async throws -> Response {
        
        req.logger.info("calling UserManagement.usersettings POST")
        req.logger.info("incomming request: \(req.body)")
        
        let body: UserManagementDictDTO = try req.content.decode(UserManagementDictDTO.self)
        guard let record: UserManagementUserSettingsModel = try await UserManagementUserSettingsModel
            .query(on: req.db)
            .filter(\.$key == body.key!)
            .filter(\.$userId == body.userId!)
            .first()
        else {
            /* no value found for given record so create */
            let newRecord: UserManagementUserSettingsModel =
            UserManagementUserSettingsModel(key: body.key!, value: body.value!, userId: body.userId!)
            _ = try await newRecord.save(on: req.db)
            
            
            let ret: Response = Response()
            ret.status = HTTPResponseStatus.created
            ret.body = Response.Body(string: "\(body.key!) has been created with value: \(body.value!)")
            return ret
        }
        record.value = body.value ?? ""
        _ = try await record.save(on: req.db)
        
        let ret: Response = Response()
        ret.status = HTTPResponseStatus.accepted
        ret.body = Response.Body(string: "\(body.key!) has been updated with value: \(body.value!)")
        req.logger.info("\(body.key!) has been updated with value: \(body.value!)")
        return ret
    }
    
    @Sendable
    func updateUserManagementAddressFields(_ req: Request) async throws -> Response {
        req.logger.notice("calling UserManagement.updateUserManagementAddressFields POST")
        req.logger.debug("incomming request: \(req.body)")
        
        /* retrieve tabSettings */
        let tabIndicator: String? = "details"
        let selectedAccordionPanel: String? = "Address Details"
        
        /* retrieve actionIndicator */
        var selectedAction = try? req.query.get(String.self, at: "action")
        if (selectedAction == nil) { selectedAction = "edit" }
        req.logger.info("UserManagement.userList selectedAction: \(String(describing:selectedAction))")
        
        /* retrieve user information */
        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? nil
        
        /* get selected user */
        let selectedUserIdString = try? req.query.get(String.self, at: "selectedUserId")
        let selectedUserId = UUID(uuidString: selectedUserIdString ?? "") ?? nil
        req.logger.info("UserManagement.userList selectedUserIdString: \(String(describing:selectedUserIdString))")
        
        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO =
        try await getUserPermissionSettings(req: req, userId: userId!, selectedUserId: userId!)
        
        /* retrieve user permissions for selected user */
        let mySelectedUserPermissionsDTO: UserManagementRoleModelDTO =
        try await getUserPermissionSettings(req: req, userId: selectedUserId!, selectedUserId: selectedUserId)
        
        /* retrieve organizations */
        //let myOrganizations = try await getUserOrganizations(req: req,  userId: userId!)
        //req.logger.info("userProfile.Organizations retrieved: \(myOrganizations)")
        
        /* retrieve system / user settings */
        var mySettingsDTO: SGServerSettingsDTO = try await getUserSettings(req: req, userId: userId!)
        mySettingsDTO.ShowToolbar = true
        mySettingsDTO.ShowUserBox = true
        req.logger.info("userProfile retrieved: \(mySettingsDTO)")
        
        /* decode body */
        let body: UserManagementAddressModelDTO = try req.content.decode(UserManagementAddressModelDTO.self)
        
        /* decode organizations */
        // let userOrganizationFormList: UserManagementUserOrganizationDTO = try req.content.decode(UserManagementUserOrganizationDTO.self)
        // _ = try await setUserOrganizationData(req: req, form: userOrganizationFormList, userId: userId!)
        
        /* update address info */
        let myAddressInfo: UserManagementAddressModelDTO = try await setUserAddressData(req: req, form: body, userId: selectedUserId!)
        
        /* retrieve account info */
        let myAccountInfo: UserManagementAccountModelDTO = try await getUserAccountInfo(req: req, userId: selectedUserId!)
        
        /* retrieve address info */
        //let myAddressInfo: UserManagementAddressModelDTO = try await getUserAddressData(req: req, userId: selectedUserId!)
        
        /* retrieve organizations */
        let myOrganizations = try await getUserOrganizations(req: req,  userId: selectedUserId!)
        req.logger.info("userProfile.Organizations retrieved: \(myOrganizations)")
        
        /* create return message */
        return try await req.view.render("UserManagement",
                                         UserBaseContext(title: "SGServer",
                                                         successMessage: "Record updated",
                                                         settings: mySettingsDTO,
                                                         tabIndicator: tabIndicator,
                                                         actionIndicator: selectedAction,
                                                         userPermissions: myUserPermissionsDTO,
                                                         userOrganizations: myOrganizations,
                                                         userAccountData: myAccountInfo,
                                                         userDetail: myAddressInfo,
                                                         selectedUserId: selectedUserIdString,
                                                         selectedUserPermissions: mySelectedUserPermissionsDTO,
                                                         selectedAccordionPanel: selectedAccordionPanel))
        .encodeResponse(for: req)
    }
    
    @Sendable
    func updateUserManagementOrganizations(_ req: Request) async throws -> Response {
        req.logger.notice("calling UserManagement.updateUserManagementOrganizations POST")
        req.logger.debug("incomming request: \(req.body)")
        
        /* retrieve tabSettings */
        let tabIndicator: String? = "details"
        let selectedAccordionPanel: String? = "Organization Details"
        
        /* retrieve actionIndicator */
        var selectedAction = try? req.query.get(String.self, at: "action")
        if (selectedAction == nil) { selectedAction = "edit" }
        req.logger.info("UserManagement.userList selectedAction: \(String(describing:selectedAction))")
        
        /* retrieve user information */
        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? nil
        
        /* get selected user */
        let selectedUserIdString = try? req.query.get(String.self, at: "selectedUserId")
        let selectedUserId = UUID(uuidString: selectedUserIdString ?? "") ?? nil
        req.logger.info("UserManagement.userList selectedUserIdString: \(String(describing:selectedUserIdString))")
        
        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO =
        try await getUserPermissionSettings(req: req, userId: userId!, selectedUserId: userId!)
        
        /* retrieve user permissions for selected user */
        let mySelectedUserPermissionsDTO: UserManagementRoleModelDTO =
        try await getUserPermissionSettings(req: req, userId: selectedUserId!, selectedUserId: selectedUserId)
        
        /* retrieve organizations */
        //let myOrganizations = try await getUserOrganizations(req: req,  userId: userId!)
        //req.logger.info("userProfile.Organizations retrieved: \(myOrganizations)")
        
        /* retrieve system / user settings */
        var mySettingsDTO: SGServerSettingsDTO = try await getUserSettings(req: req, userId: userId!)
        mySettingsDTO.ShowToolbar = true
        mySettingsDTO.ShowUserBox = true
        req.logger.info("userProfile retrieved: \(mySettingsDTO)")
        
        /* decode body */
        //let body: UserManagementAddressModelDTO = try req.content.decode(UserManagementAddressModelDTO.self)
        
        /* decode organizations */
        let userOrganizationFormList: UserManagementUserOrganizationDTO = try req.content.decode(UserManagementUserOrganizationDTO.self)
        _ = try await setUserOrganizationData(req: req, form: userOrganizationFormList, userId: selectedUserId!)
        
        /* update address info */
        // let myAddressInfo: UserManagementAddressModelDTO = try await setUserAddressData(req: req, form: body, userId: userId!)
        
        /* retrieve account info */
        let myAccountInfo: UserManagementAccountModelDTO = try await getUserAccountInfo(req: req, userId: selectedUserId!)
        
        /* retrieve address info */
        let myAddressInfo: UserManagementAddressModelDTO = try await getUserAddressData(req: req, userId: selectedUserId!)
        
        /* retrieve organizations */
        let myOrganizations = try await getUserOrganizations(req: req,  userId: selectedUserId!)
        req.logger.info("userProfile.Organizations retrieved: \(myOrganizations)")
        
        /* create return message */
        return try await req.view.render("UserManagement",
                                         UserBaseContext(title: "SGServer",
                                                         successMessage: "Record updated",
                                                         settings: mySettingsDTO,
                                                         tabIndicator: tabIndicator,
                                                         actionIndicator: selectedAction,
                                                         userPermissions: myUserPermissionsDTO,
                                                         userOrganizations: myOrganizations,
                                                         userAccountData: myAccountInfo,
                                                         userDetail: myAddressInfo,
                                                         selectedUserId: selectedUserIdString,
                                                         selectedUserPermissions: mySelectedUserPermissionsDTO,
                                                         selectedAccordionPanel: selectedAccordionPanel))
        .encodeResponse(for: req)
    }
    
    @Sendable
    func updateUserManagementAccountFields(_ req: Request) async throws -> Response {
        req.logger.notice("calling UserManagementUserManagement.updateUserManagementAccountFields POST")
        req.logger.debug("incomming request: \(req.body)")

         /* retrieve tabSettings */
        var errorMessage: String?
        var successMessage: String?
        let tabIndicator: String? = "details"
        let selectedAccordionPanel: String? = "Account Details";
        
        /* retrieve actionIndicator */
        var selectedAction = try? req.query.get(String.self, at: "action")
        if (selectedAction == nil) { selectedAction = "edit" }
        req.logger.info("UserManagement.userList selectedAction: \(String(describing:selectedAction))")

        /* retrieve user information */
        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? nil
        
        /* get selected user */
        var selectedUserIdString = try? req.query.get(String.self, at: "selectedUserId")
        var selectedUserId = UUID(uuidString: selectedUserIdString ?? "") ?? nil
        req.logger.info("UserManagement.userList selectedUserIdString: \(String(describing:selectedUserIdString))")

        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO =
            try await getUserPermissionSettings(req: req, userId: userId!, selectedUserId: userId!)

        /* retrieve organizations */
        let myOrganizations = try await getUserOrganizations(req: req,  userId: selectedUserId!)
        req.logger.info("UserManagement.Organizations retrieved: \(myOrganizations)")

        /* retrieve system / user settings */
        var mySettingsDTO: SGServerSettingsDTO = try await getUserSettings(req: req, userId: userId!)
        mySettingsDTO.ShowToolbar = true
        mySettingsDTO.ShowUserBox = true
        req.logger.info("UserManagement retrieved: \(mySettingsDTO)")
        
        /* retrieve user permissions for selected user */
        let mySelectedUserPermissionsDTO: UserManagementRoleModelDTO =
        try await getUserPermissionSettings(req: req, userId: selectedUserId!, selectedUserId: selectedUserId)
        

        /* decode body */
        let body: UserManagementAccountModelDTO = try req.content.decode(UserManagementAccountModelDTO.self)
        if selectedAction == "add" {
            /* create new userId */
            selectedUserIdString = UUID().uuidString
            selectedUserId = UUID(uuidString: selectedUserIdString ?? "") ?? nil
        }
        /* update address info */
        let myAccountInfoStatus: Bool = try await setUserAccountInfo(req: req, form: body, userId: selectedUserId!, actionIndicator: selectedAction)
        if myAccountInfoStatus {
            if selectedAction == "add" {
                successMessage = "Account Details created"
                req.logger.info("\(successMessage ?? "")")
            } else {
                successMessage = "Account Details updated"
                req.logger.info("\(successMessage ?? "")")
            }
            /* change action from add to edit mode */
            selectedAction = "edit"
        } else {
            if selectedAction == "add" {
                errorMessage = "Account Details could not be created!"
                req.logger.info("\(errorMessage ?? "")")
            }
            else {
                errorMessage = "Account Details could not be updated!"
                req.logger.error("\(errorMessage ?? "")")
            }
            
        }
        let myAccountInfo: UserManagementAccountModelDTO = try await getUserAccountInfo(req: req, userId: selectedUserId!)

        /* retrieve account info */
        //let myAccountInfo2: UserManagementAccountModelDTO = try await getUserAccountInfo(req: req, userId: userId!)

        /* retrieve address info */
        let myAddressInfo: UserManagementAddressModelDTO = try await getUserAddressData(req: req, userId: selectedUserId!)

        /* create return message */
        return try await req.view.render("UserManagement",
                            UserBaseContext(title: "SGServer",
                                            errorMessage: errorMessage,
                                            successMessage: successMessage,
                                            settings: mySettingsDTO,
                                            tabIndicator: tabIndicator,
                                            actionIndicator: selectedAction,
                                            userPermissions: myUserPermissionsDTO,
                                            userOrganizations: myOrganizations,
                                            userAccountData: myAccountInfo,
                                            userDetail: myAddressInfo,
                                            selectedUserId: selectedUserIdString,
                                            selectedUserPermissions: mySelectedUserPermissionsDTO,
                                            selectedAccordionPanel: selectedAccordionPanel))
            .encodeResponse(for: req)
    }
    
}
