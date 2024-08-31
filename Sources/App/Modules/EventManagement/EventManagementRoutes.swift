import Fluent
import Vapor


func EventManagementRoutes(_ app: Application) throws {
    let pg: any RoutesBuilder = app.grouped("events")
    pg.get { req async throws in
        try await req.view.render("landingpage")
    }

    try app.register(collection: EventManagementUserController())
}
