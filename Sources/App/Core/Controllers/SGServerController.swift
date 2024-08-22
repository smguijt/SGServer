import Fluent
import Vapor
import Leaf

struct SGServerController: RouteCollection {
    
    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view")
            .grouped(AuthenticationSessionMiddleware())
        pg.get(use: self.index)
    }

    
    @Sendable
    func index(req: Request) async throws -> View {
        var mySettingsDTO = try await getSettings(req: req)
        if req.session.data["sgsoftware_system_user"] ?? "n/a" != "n/a" {
            let userId = UUID(req.session.data["sgsoftware_system_user"] ?? "")
            mySettingsDTO = try await getUserSettings(req: req, userId: userId!)
            mySettingsDTO.ShowUserBox = true
        }
        return try await req.view.render("Index", BaseContext(title: "SGServer", settings: mySettingsDTO))
    }

}