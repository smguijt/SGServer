// UserManagementUserLogin
import Fluent
import Vapor
import Leaf

struct UserManagementUserLoginController: RouteCollection {
    
    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view").grouped("user")

        pg.get("login", use: self.renderUserLogin)
        //pg.post("login", "general", use: self.updateUserProfileGeneral)
        pg.get("logout", use: self.renderUserLogout)
    }

    @Sendable
    func renderUserLogin(req: Request) async throws -> View {
        req.logger.info("calling UserManagement.userLogin")
        req.session.destroy()

        var mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
        mySettingsDTO.ShowUserBox = false
        req.logger.info("userProfile retrieved: \(mySettingsDTO)")
        return try await req.view.render("UserManagementUserLogin", 
                                    BaseContext(title: "UserManagement", 
                                                   settings: mySettingsDTO))
    }

    @Sendable
    func renderUserLogout(req: Request) async throws -> View {
        req.logger.info("calling UserManagement.userLogout")
        req.session.destroy()

        var mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
        mySettingsDTO.ShowUserBox = false
        return try await req.view.render("UserManagementUserLogin", 
                                    BaseContext(title: "UserManagement", 
                                                   settings: mySettingsDTO))
    }

    @Sendable
    func validateUserLogin(_ req: Request) async throws -> Response {
        req.logger.info("calling UserManagement.validateUserLogin")
        req.logger.info("incomming request: \(req.body)")


        let user: UserManagementUserLoginDTO = try req.content.decode(UserManagementUserLoginDTO.self)
        
        guard let existingUser: UserManagementAccountModel = try await UserManagementAccountModel
            .query(on: req.db)
            .filter(\.$email == user.username!)
            .filter(\.$orgId == user.orgId!)
            .first() 
        else {
            /* user could not be found */
           let mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
                return try await req.view.render("UserManagementUserLogin", 
                                    BaseContext(title: "UserManagement", 
                                                errorMessage: "Invalid user credentials",
                                                settings: mySettingsDTO))
                    .encodeResponse(for: req)

        }

        guard try existingUser.verify(password: user.password ?? "") else {
            /* invalid password provided */
            let mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
                return try await req.view.render("UserManagementUserLogin", 
                                    BaseContext(title: "UserManagement", 
                                                errorMessage: "Invalid user credentials",
                                                settings: mySettingsDTO))
                    .encodeResponse(for: req)
        }

        /* all is ok set session */
        req.session.data["name"] = existingUser.id?.uuidString
        req.session.data["ops"] = existingUser.orgId
        return req.redirect(to: "/view/?id=\(existingUser.id?.uuidString ?? "")&ops=\(existingUser.orgId ?? "")")

    }

}