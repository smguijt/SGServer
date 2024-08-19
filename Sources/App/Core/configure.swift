import NIOSSL
import Fluent
import FluentSQLiteDriver
import Leaf
import LeafErrorMiddleware
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) async throws {

    app.logger.info("Enable middleware:FileMiddleware")
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    /* serve error pages */
    app.logger.info("Enable middleware:LeafErrorMiddleware")
    let mappings: [HTTPStatus: String] = [
        .notFound: "404",
        .unauthorized: "401",
        .forbidden: "403",
        .internalServerError: "serverError"
    ]
    app.middleware.use(LeafErrorMiddlewareDefaultGenerator.build(errorMappings: mappings))

    // init database
    app.logger.info("Initialize database")
    app.databases.use(.sqlite(.memory), as: .sqlite)

    // enable session support
    app.logger.info("Enable Session")
    app.sessions.use(.fluent)
    app.middleware.use(app.sessions.middleware)
    
    /* Create database objects */
    app.logger.info("Create database objects")
    app.migrations.add(SessionRecord.migration)
    try CreateDatabaseModels(app)

    app.logger.info("Seed database objects")
    try SeedDatabaseModels(app)

     /* auto migrate */
    app.logger.info("automigration executed")
    try await app.autoMigrate()

    /* add JWT support */
    app.jwt.signers.use(.hs256(key: Environment.get("SECRETKEY") ?? "SGSoftware"))

    // serve views
    app.logger.info("Enable view engine .leaf")
    app.logger.info("template dir: \(app.leaf.configuration.rootDirectory)")
    app.views.use(.leaf)
    app.leaf.tags["now"] = NowTag()
    app.leaf.tags["appNameTag"] = AppNameTag()

    // configure default port
    app.logger.info("Default port set to 8080 for SGServer - Backend Service")
    app.http.server.configuration.port = 8080

    // register routes
    try routes(app)
}
