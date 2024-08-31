import Fluent
import Vapor
import Leaf

struct TimeManagementUserController: RouteCollection {

    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view")
            .grouped("module")
            .grouped("timemanagement")
            .grouped(AuthenticationSessionMiddleware())

        pg.get("", use: self.renderList)
    }

     @Sendable
    func renderList(req: Request) async throws -> View {

        req.logger.info("calling TimeManagement.List")

        /* get login user */
        let userIdString = req.session.data["sgsoftware_system_user"] ?? ""
        let userId = UUID(uuidString: userIdString ?? "") ?? nil

        /* retrieve settings */
        var mySettingsDTO = try await getSettings(req: req)
        if req.session.data["sgsoftware_system_user"] ?? "n/a" != "n/a" {
            let userId = UUID(req.session.data["sgsoftware_system_user"] ?? "")
            mySettingsDTO = try await getUserSettings(req: req, userId: userId!)
            mySettingsDTO.ShowUserBox = true
        }

        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO = 
            try await getUserPermissionSettings(req: req, userId: userId!)

         return try await req.view.render("TimeManagement", 
            TimeBaseContext(title: "SGServer", 
                            settings: mySettingsDTO, 
                            userPermissions: myUserPermissionsDTO))
    }
}