import Fluent
import Vapor


func TaskManagementRoutes(_ app: Application) throws {
    let pg: any RoutesBuilder = app.grouped("tasks")
    pg.get { req async throws in
        try await req.view.render("landingpage")
    }

    try app.register(collection: TaskManagementUserController())
}
