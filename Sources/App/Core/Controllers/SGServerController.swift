import Fluent
import Vapor
import Leaf

struct SGServerController: RouteCollection {
    
    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view")
        
        pg.get(use: self.index)
    }

    
    @Sendable
    func index(req: Request) async throws -> View {
        let mySettingsDTO = try await getSettings(req: req)
        return try await req.view.render("Index", BaseContext(title: "SGServer", settings: mySettingsDTO))
    }

}