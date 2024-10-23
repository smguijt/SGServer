import Foundation
import Fluent
import Vapor



func getQueryParams(req: Request) async throws -> queryParamsDTO {

    /* get login user */
    let userIdString = req.session.data["sgsoftware_system_user"] ?? ""
    let userId: UUID? = UUID(uuidString: userIdString) ?? nil

    /* get selected organization */
    var selectedOrg = try? req.query.get(String.self, at: "org")
    if (selectedOrg == nil) { selectedOrg = "" }

    /* get selectedAction */
    var selectedAction = try? req.query.get(String.self, at: "action")
    if (selectedAction == nil) { selectedAction = "list" }

    /* retrieve tabSettings */
    var tabIndicator: String? = try? req.query.get(String.self, at: "tabid")
    if (tabIndicator == nil) {
        tabIndicator = "general"
    }

    /* retrieve filter */
    var filter: String? = try? req.query.get(String.self, at: "filter")
    if (filter == nil) {
        filter = ""
    }

    /* get settings */
    var mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
    if req.session.data["sgsoftware_system_user"] ?? "n/a" != "n/a" {
        let userId = UUID(req.session.data["sgsoftware_system_user"] ?? "")
        mySettingsDTO = try await getUserSettings(req: req, userId: userId!)
        mySettingsDTO.ShowUserBox = true
        mySettingsDTO.ShowToolbar = true
    }

    /* retrieve organizations */
    let myOrganizations: [UserManagementOrganizationModelDTO] = try await getUserOrganizations(req: req,  userId: userId!, filterByUser: true)

    /* retrieve user permissions */
    let myUserPermissionsDTO: UserManagementRoleModelDTO =
        try await getUserPermissionSettings(req: req, userId: userId!, selectedUserId: userId!)

    /* return */
    return queryParamsDTO(userId: userId, 
                          orgId: UUID(uuidString: selectedOrg!),
                          tabIndicator: tabIndicator,
                          actionIndicator: selectedAction,
                          settings: mySettingsDTO,
                          organizations: myOrganizations,
                          permissions: myUserPermissionsDTO,
                          filter: filter
                        )
}