import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("landingpage")
    }

    

    /* setup API controllers */
    try app.register(collection: SGServerSettingsApiController())
    
    /* setup VIEW controllers */
    try app.register(collection: SGServerController())
    try app.register(collection: SGServerSettingsController())

    /* init the module routes */
    try UserManagementRoutes(app)
    try EventManagementRoutes(app)
    try TimeManagementRoutes(app)
    try TaskManagementRoutes(app)
}
