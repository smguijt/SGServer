import Fluent
import Vapor
import Leaf

struct EventManagementUserController: RouteCollection {

    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view")
            .grouped("module")
            .grouped("eventmanagement")
            .grouped(AuthenticationSessionMiddleware())

        pg.get("", use: self.checkOrganization)
        pg.get("index", use: self.renderList)
        pg.post("selectedorganization", use: self.selectedorganization)
    }

     @Sendable
    func renderList(req: Request) async throws -> View {

        req.logger.info("calling EventManagement.List")

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

        /* get selected organization */
        var selectedOrg = try? req.query.get(String.self, at: "org")
        if (selectedOrg == nil) { selectedOrg = "" }
        req.logger.info("EventManagement.renderList selectedOrg: \(String(describing:selectedOrg))")

        /* retrieve user permissions */
        let myUserPermissionsDTO: UserManagementRoleModelDTO = 
            try await getUserPermissionSettings(req: req, userId: userId!, selectedUserId: userId!)

        /* retrieve organizations */
        let myOrganizations = try await getUserOrganizations(req: req,  userId: userId!, filterByUser: true)

         return try await req.view.render("EventManagement", 
            EventBaseContext(title: "SGServer", 
                            settings: mySettingsDTO, 
                            orgIndicator: selectedOrg,
                            userPermissions: myUserPermissionsDTO,
                            userOrganizations: myOrganizations))
    }

    @Sendable
    func selectedorganization(_ req: Request) async throws -> Response {
        req.logger.notice("calling EventManagement.selectedorganization POST")
        req.logger.debug("incomming request: \(req.body)")

        /* decode body */
        let body: EventManagementOrganizationDTO = try req.content.decode(EventManagementOrganizationDTO.self)
        let _selectedorganization: String = body.organization ?? ""
        req.logger.info("EventManagement.selectedorganization POST: \(String(describing:selectedorganization))")

        return req.redirect(to: "/view/module/eventmanagement/?org=\(_selectedorganization)")
    }

    @Sendable
    func checkOrganization(_ req: Request) async throws -> Response {
        req.logger.notice("calling EventManagement.checkOrganization POST")

        /* get login user */
        let userIdString = req.session.data["sgsoftware_system_user"] ?? ""
        let userId = UUID(uuidString: userIdString) ?? nil

        var _selectedorganization: String = ""
        if _selectedorganization == "" {
            /* get selected organization */
            var selectedOrg = try? req.query.get(String.self, at: "org")
            if (selectedOrg == nil) { selectedOrg = "" }
            req.logger.info("EventManagement.renderList selectedOrg: \(String(describing:selectedOrg))")
            if (selectedOrg != "") {
                _selectedorganization = selectedOrg ?? ""
            } else {
                /* retrieve organizations */
                req.logger.info("EventManagement.renderList retrieve organization linked to user")
                let myOrganizations = try await getUserOrganizations(req: req,  userId: userId!, filterByUser: true)
                req.logger.info("EventManagement.renderList myOrganizations: \(String(describing:myOrganizations))")
                if (myOrganizations.count > 0) {
                    if (myOrganizations.count > 1) {
                        _selectedorganization = ""
                        req.logger.info("EventManagement.renderList _selectedorganization (linked to user): More than one organization found..")
                    } else {
                        _selectedorganization = myOrganizations[0].code ?? ""
                        req.logger.info("EventManagement.renderList _selectedorganization (linked to user): \(String(describing:selectedOrg))")
                    }
                } else {
                    req.logger.info("EventManagement.renderList _selectedorganization (linked to user): No organization found..")
                }
            }
        }
        
        if _selectedorganization == "" {
            return req.redirect(to: "/view/module/eventmanagement/index") 
        } else {
            return req.redirect(to: "/view/module/eventmanagement/index?org=\(_selectedorganization)")
        }
    }

}
