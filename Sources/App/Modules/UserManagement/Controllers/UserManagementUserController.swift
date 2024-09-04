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
    }

     @Sendable
    func renderUserList(req: Request) async throws -> View {

        req.logger.info("calling UserManagement.userList")

        /* get login user */
        let userIdString = req.session.data["sgsoftware_system_user"] ?? ""
        let userId: UUID? = UUID(uuidString: userIdString ?? "") ?? nil
        req.logger.info("UserManagement.userList userId: \(userIdString)")
        
        /* get selected user */
        let selectedUserIdString = try? req.query.get(String.self, at: "selectedUserId")
        //let selectedUserId = UUID(uuidString: selectedUserIdString ?? "") ?? nil
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
            try await getUserPermissionSettings(req: req, userId: userId!)

        /* get userlist */
        let userList = try await getUserList(req: req, userId: userId!)

         return try await req.view.render("UserManagement", 
            UserListContext(title: "SGServer", 
                            settings: mySettingsDTO, 
                            tabIndicator: tabIndicator,
                            userPermissions: myUserPermissionsDTO,
                            userList: userList,
                            selectedUserId: selectedUserIdString))
    }
}