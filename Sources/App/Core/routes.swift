import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("landingpage")
    }

    /* init the module routes */
    try UserManagementRoutes(app)
    try EventManagementRoutes(app)
    try TimeManagementRoutes(app)
    try TaskManagementRoutes(app)
}
