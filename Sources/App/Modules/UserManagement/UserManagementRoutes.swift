import Fluent
import Vapor


func UserManagementRoutes(_ app: Application) throws {
    let pg: any RoutesBuilder = app.grouped("users")
    pg.get { req async throws in
        try await req.view.render("landingpage")
    }

    /* setup API controllers */
    //...
    
    /* setup VIEW controllers */
    try app.register(collection: UserManagementUserLoginController())
    try app.register(collection: UserManagementUserSettingsController())
    try app.register(collection: UserManagementUserProfileController())
    try app.register(collection: UserManagementUserController())

}
