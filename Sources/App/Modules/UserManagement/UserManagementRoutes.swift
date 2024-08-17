import Fluent
import Vapor


func UserManagementRoutes(_ app: Application) throws {
    let pg: any RoutesBuilder = app.grouped("users")
    pg.get { req async throws in
        try await req.view.render("landingpage")
    }
}
