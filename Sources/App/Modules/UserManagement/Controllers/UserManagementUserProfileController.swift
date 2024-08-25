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
        pg.post("profile", "customfields", use: self.updateUserProfileCustomFields)
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


        /* return */
        return try await req.view.render("UserManagementUserProfile", 
                                    UserBaseContext(title: "SGServer", 
                                                   settings: mySettingsDTO, 
                                                   tabIndicator: tabIndicator,
                                                   userPermissions: myUserPermissionsDTO))
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

        let body: UserManagementDictDTO = try req.content.decode(UserManagementDictDTO.self)

        let ret: Response = Response()
        ret.status = HTTPResponseStatus.conflict
        ret.body = Response.Body(string: "\(body.key!) is not a valid key!")
        req.logger.info("\(body.key!) is not a valid key!")

/*

        /* determine user */
        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_system_user"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? UUID()
        req.logger.info("calling UserManagementUserProfile.updateUserProfilePermissions.id POST: \(userId)")

        /* decode */
        let body: UserManagementDictDTO = try req.content.decode(UserManagementDictDTO.self)

        /* translate value */
        
        var record: UserManagementRoleModel? = nil
        switch body.key {
            case "isAdminUser":
                
                record = try await UserManagementRoleModel
                            .query(on: req.db)
                            .filter(\.$role == UserManagementRoleEnum.admin.rawValue)
                            .filter(\.$userId == body.userId!)
                            .first() ?? UserManagementRoleModel(role: UserManagementRoleEnum.admin.rawValue, 
                                                                userId: body.userId!)
                

                break
            default:
                ret.status = HTTPResponseStatus.conflict
                ret.body = Response.Body(string: "\(body.key!) is not a valid key!")
                req.logger.info("\(body.key!) is not a valid key!")
                break
        }

        /*
        if record == nil {
            let newRecord: UserManagementRoleModel = 
                UserManagementRoleModel(role: body.key!, userId: body.userId!)
            _ = try await newRecord.save(on: req.db)

            let ret: Response = Response()
            ret.status = HTTPResponseStatus.created
            ret.body = Response.Body(string: "\(body.key!) has been created with value: \(body.value!)")
            return ret
        }
        */

        /* update record */
        //record.$role = body.value 
        //_ = try await record.save(on: req.db)

        /* return response */
        ret.status = HTTPResponseStatus.accepted
        ret.body = Response.Body(string: "\(body.key!) has been updated with value: \(body.value!)")
        req.logger.info("\(body.key!) has been updated with value: \(body.value!)")
*/
        return ret
    }

}