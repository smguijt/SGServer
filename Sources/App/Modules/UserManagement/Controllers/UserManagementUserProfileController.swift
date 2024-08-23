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

}