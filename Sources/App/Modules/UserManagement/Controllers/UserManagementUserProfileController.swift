// UserManagementUserProfile
import Fluent
import Vapor
import Leaf

struct UserManagementUserProfileController: RouteCollection {
    
    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view").grouped("user").grouped(AuthenticationSessionMiddleware())

        pg.get("profile", use: self.renderUserProfile)
        pg.post("profile", "general", use: self.updateUserProfileGeneral)
        //pg.post("profile", "customfields", use: self.updateUserProfileCustomFields)
        
        pg.get("profile", "address", use: self.renderUserProfile)
        pg.post("profile", "address", use: self.updateUserProfileAddressFields)
        
        pg.get("profile", "account", use: self.renderUserProfile)
        pg.post("profile", "account", use: self.updateUserProfileAccountFields)


        pg.post("profile", "permissions", use: self.updateUserProfilePermissions)
    }

    @Sendable
    func renderUserProfile(req: Request) async throws -> View {

        req.logger.info("calling UserManagement.userProfile")
        
        /* retrieve tabSettings */
        var tabIndicator: String? = try? req.query.get(String.self, at: "tabid")
        if (tabIndicator == nil) { 
            tabIndicator = "general"
        } 

        /* retrieve user information */
        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? nil

        /* retrieve system / user settings */
        var mySettingsDTO: SGServerSettingsDTO = try await getUserSettings(req: req, userId: userId!)
        mySettingsDTO.ShowToolbar = true
        mySettingsDTO.ShowUserBox = true
        req.logger.info("userProfile retrieved: \(mySettingsDTO)")

        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO = 
            try await getUserPermissionSettings(req: req, userId: userId!)

        /* retrieve organizations */
        let myOrganizations = try await getUserOrganizations(req: req,  userId: userId!)
        req.logger.info("userProfile.Organizations retrieved: \(myOrganizations)")

         /* retrieve account info */
        let myAccountInfo: UserManagementAccountModelDTO = try await getUserAccountInfo(req: req, userId: userId!)

        /* retrieve address info */
        let myAddressInfo: UserManagementAddressModelDTO = try await getUserAddressData(req: req, userId: userId!)

        /* return */
        return try await req.view.render("UserManagementUserProfile", 
                                    UserBaseContext(title: "SGServer", 
                                                   settings: mySettingsDTO, 
                                                   tabIndicator: tabIndicator,
                                                   userPermissions: myUserPermissionsDTO,
                                                   userOrganizations: myOrganizations,
                                                   userAccountData: myAccountInfo,
                                                   userDetail: myAddressInfo))
    }

    @Sendable
    func updateUserProfileGeneral(_ req: Request) async throws -> Response {
        req.logger.info("calling UserManagementUserProfile.updateUserProfileGeneral POST")
        req.logger.info("incomming request: \(req.body)")

        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? UUID()
        req.logger.info("calling UserManagementUserProfile.updateUserProfileGeneral.id POST: \(userId)")

        /* decode form */
        /* validate form */
        /* redirect form if invalid */
        /* save form if valid */

        /*
        let ret: Response = Response()
        ret.status = HTTPResponseStatus.notImplemented
        return ret
        */

        return req.redirect(to: "/view/user/profile")
    }

    @Sendable
    func updateUserProfileCustomFields(_ req: Request) async throws -> Response {
        req.logger.info("calling UserManagementUserProfile.updateUserProfileCustomFields POST")
        req.logger.info("incomming request: \(req.body)")

        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? UUID()
        req.logger.info("calling UserManagementUserProfile.updateUserProfileCustomFields.id POST: \(userId)")

        /* decode form */
        /* validate form */
        /* redirect form if invalid */
        /* save form if valid */

        /*
        let ret: Response = Response()
        ret.status = HTTPResponseStatus.notImplemented
        return ret
        */

        return req.redirect(to: "/view/user/profile")
    }

    @Sendable
    func updateUserProfilePermissions(_ req: Request) async throws -> Response {

        req.logger.info("calling UserManagementUserProfile.updateUserProfilePermissions POST")
        req.logger.info("incomming request: \(req.body)")

        /* determine user */
        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? UUID()
        req.logger.info("calling UserManagementUserProfile.updateUserProfilePermissions.id POST: \(userId)")

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
    func updateUserProfileAddressFields(_ req: Request) async throws -> Response {
        req.logger.info("calling UserManagementUserProfile.updateUserProfileAddressFields POST")
        req.logger.info("incomming request: \(req.body)")

        /* retrieve tabSettings */
        let tabIndicator: String? = "addressdetails"

        /* retrieve user information */
        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? nil

        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO = 
            try await getUserPermissionSettings(req: req, userId: userId!)

        /* retrieve organizations */
        let myOrganizations = try await getUserOrganizations(req: req,  userId: userId!)
        req.logger.info("userProfile.Organizations retrieved: \(myOrganizations)")
        
        /* retrieve system / user settings */
        var mySettingsDTO: SGServerSettingsDTO = try await getUserSettings(req: req, userId: userId!)
        mySettingsDTO.ShowToolbar = true
        mySettingsDTO.ShowUserBox = true
        req.logger.info("userProfile retrieved: \(mySettingsDTO)")

        /* decode body */
        let body: UserManagementAddressModelDTO = try req.content.decode(UserManagementAddressModelDTO.self)

        /* update address info */
        let myAddressInfo: UserManagementAddressModelDTO = try await setUserAddressData(req: req, form: body, userId: userId!)
        
        /* retrieve account info */
        let myAccountInfo: UserManagementAccountModelDTO = try await getUserAccountInfo(req: req, userId: userId!)

        /* retrieve address info */
        //let myAddressInfo: UserManagementAddressModelDTO = try await getUserAddressData(req: req, userId: userId!)

        /* create return message */        
        return try await req.view.render("UserManagementUserProfile", 
                            UserBaseContext(title: "SGServer", 
                                            successMessage: "Record updated",
                                            settings: mySettingsDTO, 
                                            tabIndicator: tabIndicator,
                                            userPermissions: myUserPermissionsDTO,
                                            userOrganizations: myOrganizations,
                                            userAccountData: myAccountInfo,
                                            userDetail: myAddressInfo))
            .encodeResponse(for: req)
    }

    @Sendable
    func updateUserProfileAccountFields(_ req: Request) async throws -> Response {
        req.logger.info("calling UserManagementUserProfile.updateUserProfileAccountFields POST")
        req.logger.info("incomming request: \(req.body)")

         /* retrieve tabSettings */
        let tabIndicator: String? = "accountdetails"

        /* retrieve user information */
        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? nil

        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO = 
            try await getUserPermissionSettings(req: req, userId: userId!)

        /* retrieve organizations */
        let myOrganizations = try await getUserOrganizations(req: req,  userId: userId!)
        req.logger.info("userProfile.Organizations retrieved: \(myOrganizations)")

        /* retrieve system / user settings */
        var mySettingsDTO: SGServerSettingsDTO = try await getUserSettings(req: req, userId: userId!)
        mySettingsDTO.ShowToolbar = true
        mySettingsDTO.ShowUserBox = true
        req.logger.info("userProfile retrieved: \(mySettingsDTO)")

        /* retrieve account info */
        let myAccountInfo: UserManagementAccountModelDTO = try await getUserAccountInfo(req: req, userId: userId!)

        /* retrieve address info */
        let myAddressInfo: UserManagementAddressModelDTO = try await getUserAddressData(req: req, userId: userId!)

        /* create return message */        
        return try await req.view.render("UserManagementUserProfile", 
                            UserBaseContext(title: "SGServer", 
                                            errorMessage: "Under Construction!",
                                            settings: mySettingsDTO, 
                                            tabIndicator: tabIndicator,
                                            userPermissions: myUserPermissionsDTO,
                                            userOrganizations: myOrganizations,
                                            userAccountData: myAccountInfo,
                                            userDetail: myAddressInfo))
            .encodeResponse(for: req)
    }

}