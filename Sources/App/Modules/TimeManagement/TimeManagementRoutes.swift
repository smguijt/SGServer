import Fluent
import Vapor


func TimeManagementRoutes(_ app: Application) throws {
    let pg: any RoutesBuilder = app.grouped("time")
    pg.get { req async throws in
        try await req.view.render("landingpage")
    }

    try app.register(collection: TimeManagementUserController())
}
