import Fluent
import Vapor


func BaswareAPIRoutes(_ app: Application) throws {
    let pg: any RoutesBuilder = app.grouped("basware")
    pg.get { req async throws in
        try await req.view.render("landingpage")
    }

    /* setup API controllers */
    //...
    
    /* setup VIEW controllers */
    try app.register(collection: BaswareAPIController())

}
