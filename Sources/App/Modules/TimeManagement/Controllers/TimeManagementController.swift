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

        pg.get("", use: self.checkOrganization)
        pg.get("index", use: self.renderList)
        pg.post("selectedorganization", use: self.selectedorganization)
    }

     @Sendable
    func renderList(req: Request) async throws -> View {

        req.logger.info("calling TimeManagement.List")

        /* get login user */
        let userIdString = req.session.data["sgsoftware_system_user"] ?? ""
        let userId = UUID(uuidString: userIdString) ?? nil

        /* retrieve settings */
        var mySettingsDTO = try await getSettings(req: req)
        if req.session.data["sgsoftware_system_user"] ?? "n/a" != "n/a" {
            let userId = UUID(req.session.data["sgsoftware_system_user"] ?? "")
            mySettingsDTO = try await getUserSettings(req: req, userId: userId!)
            mySettingsDTO.ShowUserBox = true
            mySettingsDTO.ShowToolbar = true
        }

        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO = 
            try await getUserPermissionSettings(req: req, userId: userId!, selectedUserId: userId!)

        /* retrieve organizations */
        let myOrganizations = try await getUserOrganizations(req: req,  userId: userId!, filterByUser: true)

         return try await req.view.render("TimeManagement", 
            TimeBaseContext(title: "SGServer", 
                            settings: mySettingsDTO, 
                            userPermissions: myUserPermissionsDTO,
                            userOrganizations: myOrganizations))
    }

@Sendable
    func selectedorganization(_ req: Request) async throws -> Response {
        req.logger.notice("calling TimeManagement.selectedorganization POST")
        req.logger.debug("incomming request: \(req.body)")

        /* decode body */
        let body: TimeManagementOrganizationDTO = try req.content.decode(TimeManagementOrganizationDTO.self)
        let _selectedorganization: String = body.organization ?? ""
        req.logger.info("TimeManagement.selectedorganization POST: \(String(describing:selectedorganization))")

        return req.redirect(to: "/view/module/timemanagement/?org=\(_selectedorganization)")
    }

    @Sendable
    func checkOrganization(_ req: Request) async throws -> Response {
        req.logger.notice("calling TimeManagement.checkOrganization POST")

        /* get login user */
        let userIdString = req.session.data["sgsoftware_system_user"] ?? ""
        let userId = UUID(uuidString: userIdString) ?? nil

        var _selectedorganization: String = ""
        if _selectedorganization == "" {
            /* get selected organization */
            var selectedOrg = try? req.query.get(String.self, at: "org")
            if (selectedOrg == nil) { selectedOrg = "" }
            req.logger.info("TimeManagement.renderList selectedOrg: \(String(describing:selectedOrg))")
            if (selectedOrg != "") {
                _selectedorganization = selectedOrg ?? ""
            } else {
                /* retrieve TimeManagement */
                req.logger.info("EventManagement.renderList retrieve organization linked to user")
                let myOrganizations = try await getUserOrganizations(req: req,  userId: userId!, filterByUser: true)
                req.logger.info("TimeManagement.renderList myOrganizations: \(String(describing:myOrganizations))")
                if (myOrganizations.count > 0) {
                    if (myOrganizations.count > 1) {
                        _selectedorganization = ""
                        req.logger.info("TimeManagement.renderList _selectedorganization (linked to user): More than one organization found..")
                    } else {
                        _selectedorganization = myOrganizations[0].code ?? ""
                        req.logger.info("TimeManagement.renderList _selectedorganization (linked to user): \(String(describing:selectedOrg))")
                    }
                } else {
                    req.logger.info("TimeManagement.renderList _selectedorganization (linked to user): No organization found..")
                }
            }
        }
        
        if _selectedorganization == "" {
            return req.redirect(to: "/view/module/timemanagement/index") 
        } else {
            return req.redirect(to: "/view/module/timemanagement/index?org=\(_selectedorganization)")
        }
    }

}
