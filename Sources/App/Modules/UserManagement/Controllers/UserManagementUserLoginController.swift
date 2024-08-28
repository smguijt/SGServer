// UserManagementUserLogin
import Fluent
import Vapor
import Leaf

struct UserManagementUserLoginController: RouteCollection {
    
    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view").grouped("user")

        pg.get("login", use: self.renderUserLogin)
        pg.post("login", use: self.validateUserLogin)
        pg.get("logout", use: self.renderUserLogout)
    }

    @Sendable
    func renderUserLogin(req: Request) async throws -> View {
        req.logger.info("calling UserManagement.userLogin")
        req.session.destroy()

        var mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
        mySettingsDTO.ShowUserBox = false
        return try await req.view.render("UserManagementUserLogin", 
                                    BaseContext(title: "SGServer", 
                                                   settings: mySettingsDTO))
    }

    @Sendable
    func renderUserLogout(req: Request) async throws -> View {
        req.logger.info("calling UserManagement.userLogout")
        req.session.destroy()

        var mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
        mySettingsDTO.ShowUserBox = false
        return try await req.view.render("UserManagementUserLogin", 
                                    BaseContext(title: "SGServer", 
                                                   settings: mySettingsDTO))
    }

    @Sendable
    func validateUserLogin(_ req: Request) async throws -> Response {
        req.logger.info("calling UserManagement.validateUserLogin")
        req.logger.info("incomming request: \(req.body)")

        let user: UserManagementUserLoginDTO = try req.content.decode(UserManagementUserLoginDTO.self)
        var orgId: String? = "system"
        if user.orgId != nil  {
            orgId = user.orgId ?? ""
        }
        if user.username == "" {
            req.logger.info("UserManagement.validateUserLogin -> missing clientId!!")
            let mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
                return try await req.view.render("UserManagementUserLogin", 
                                    BaseContext(title: "SGServer", 
                                                errorMessage: "Missing value for clientId",
                                                settings: mySettingsDTO))
                    .encodeResponse(for: req)
        }
        if user.password == "" {
            req.logger.info("UserManagement.validateUserLogin -> missing clientSecret!!")
            let mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
                return try await req.view.render("UserManagementUserLogin", 
                                    BaseContext(title: "SGServer", 
                                                errorMessage: "Missing value for clientSecret",
                                                settings: mySettingsDTO))
                    .encodeResponse(for: req)
        }
        
        guard let existingUser: UserManagementAccountModel = try await UserManagementAccountModel
            .query(on: req.db)
            .join(UserManagementUserOrganizationsModel.self, on: \UserManagementOrganizationModel.$id == \UserManagementUserOrganizationsModel.$orgId, method: .inner)
            .join(UserManagementOrganizationModel.self, on: \UserManagementOrganizationModel.$id == \UserManagementUserOrganizationsModel.$orgId, method: .inner)
            .filter(\.$email == user.username!)
            .filter(UserManagementOrganizationModel.self, \.$code == orgId)
            .first()
        else {
            /* user could not be found */
            req.logger.info("UserManagement.validateUserLogin -> invalid clientId!!")
           let mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
                return try await req.view.render("UserManagementUserLogin", 
                                    BaseContext(title: "SGServer", 
                                                errorMessage: "Invalid user credentials",
                                                settings: mySettingsDTO))
                    .encodeResponse(for: req)
        }

        guard try existingUser.verify(password: user.password ?? "") else {
            /* invalid password provided */
            req.logger.info("UserManagement.validateUserLogin -> invalid clientSecret!!")
            let mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
                return try await req.view.render("UserManagementUserLogin", 
                                    BaseContext(title: "SGServer", 
                                                errorMessage: "Invalid user credentials",
                                                settings: mySettingsDTO))
                    .encodeResponse(for: req)
        }

        /* all is ok set session */
        req.logger.info("UserManagement.validateUserLogin -> user validated. SET session!!")
        req.session.data["sgsoftware_system_user"] = existingUser.id?.uuidString
        req.session.data["sgsoftware_system_ops"] = existingUser.orgId
        req.logger.info("UserManagement.validateUserLogin -> user validated. redirect to main page!!")
        return req.redirect(to: "/view/?id=\(existingUser.id?.uuidString ?? "")&ops=\(existingUser.orgId ?? "")")
    }

}