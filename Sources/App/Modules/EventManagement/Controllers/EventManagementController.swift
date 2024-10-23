import Fluent
import Vapor
import Leaf

struct EventManagementUserController: RouteCollection {

    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view")
            .grouped("module")
            .grouped("eventmanagement")

        /* event registration routes */
        pg.get("eventregistration", use: self.renderRegistration)
        pg.get("eventregistration", "confirmation", use: self.renderRegistrationConfirmation)

        /* authenticated routes */
        let auth = pg.grouped(AuthenticationSessionMiddleware())
        auth.get("", use: self.checkOrganization)
        auth.get("index", use: self.renderList)
        auth.post("selectedorganization", use: self.selectedorganization)
    }

    @Sendable
    func renderRegistration(req: Request) async throws -> View {

        /* get selected organization */
        var selectedOrg = try? req.query.get(String.self, at: "org")
        if (selectedOrg == nil) { selectedOrg = "" }
        req.logger.info("EventManagement.renderRegistration selectedOrg: \(String(describing:selectedOrg))")

        /* get selected eventId */
        var selectedEventId = try? req.query.get(String.self, at: "eventId")
        if (selectedEventId == nil) { selectedEventId = "" }
        req.logger.info("EventManagement.renderRegistration selectedEventId: \(String(describing:selectedEventId))")

        /* get selected serieId */
        var selectedEventSerieId = try? req.query.get(String.self, at: "serieId")
        if (selectedEventSerieId == nil) { selectedEventSerieId = "" }
        req.logger.info("EventManagement.renderRegistration selectedEventSerieId: \(String(describing:selectedEventSerieId))")

        /* retrieve application settings */
        var mySettingsDTO = try await getSettings(req: req)
        mySettingsDTO.SidebarToggleState = true

        /* return view */
        return try await req.view.render("EventManagementRegistration", 
            EventRegistrationContext(title: "SGServer", 
                        selectedOrgId: selectedOrg, 
                        selectedEventId: selectedEventId, 
                        selectedSerieId: selectedEventSerieId,
                        settings: mySettingsDTO)) 
    }

    @Sendable
    func renderRegistrationConfirmation(req: Request) async throws -> View {
        
        /* set vars */
        var isValidated: Bool
        var errorMessage: String?
        var successMessage: String?

        /* get selected organization */
        var confirmationToken = try? req.query.get(String.self, at: "token")
        if (confirmationToken == nil) { confirmationToken = "" }
        req.logger.info("EventManagement.renderRegistrationConfirmation confirmationToken: \(String(describing:confirmationToken))")

        /* retrieve settings */
        var mySettingsDTO = try await getSettings(req: req)
         mySettingsDTO.SidebarToggleState = true

        /* validate token */
        /* .. */

        /* retrieve registration information linked to token */
        /* .. */

        /* generate response */
        isValidated = false
        successMessage = "Validated!"
        if !isValidated {
            successMessage = nil
            errorMessage = "Invalid Token"
        }

        /* generate view */
        return try await req.view.render("EventManagementRegistration", 
            EventRegistrationContext(title: "SGServer", errorMessage: errorMessage, successMessage: successMessage, settings: mySettingsDTO)) 
    }

    @Sendable
    func renderList(req: Request) async throws -> View {

        req.logger.info("calling EventManagement.List")
        let params: queryParamsDTO = try await getQueryParams(req: req)
        
        return try await req.view.render("EventManagement", 
            EventBaseContext(title: "SGServer",
                            settings: params.settings,
                            orgIndicator: params.orgId?.uuidString,
                            tabIndicator: params.tabIndicator,
                            actionIndicator: params.actionIndicator,
                            userPermissions: params.permissions,
                            userOrganizations: params.organizations,
                            filter: params.filter
                            ))
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

        var selectedFilter = try? req.query.get(String.self, at: "filter")
            if (selectedFilter == nil) { selectedFilter = "" }
        
        if _selectedorganization == "" {
            return req.redirect(to: "/view/module/eventmanagement/index") 
        } else {
            if selectedFilter != "" {
                return req.redirect(to: "/view/module/eventmanagement/index?org=\(_selectedorganization)&filter=\(selectedFilter!)&x=")
            } else {
                return req.redirect(to: "/view/module/eventmanagement/index?org=\(_selectedorganization)")
            }
            
        }
    }

}
