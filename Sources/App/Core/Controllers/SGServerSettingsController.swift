import Fluent
import Vapor
import Leaf

struct SGServerSettingsController: RouteCollection {
    
    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view")
            .grouped(AuthenticationSessionMiddleware())
        
        pg.get("systemsettings", use: self.renderSystemSettings)
        pg.post("systemsettings", use: self.updateSystemSetting)
    }

    /* SETTINGS */
    
    @Sendable
    func renderSystemSettings(req: Request) async throws -> View {
        req.logger.info("calling SGServer.systemsettings")
        let mySettingsDTO = try await getSettings(req: req)
        return try await req.view.render("SystemSettings", BaseContext(title: "SGServer", settings: mySettingsDTO))
    }
    
    @Sendable
    func updateSystemSetting(_ req: Request) async throws -> Response {
        req.logger.info("calling SGServer.systemsettings POST")
        req.logger.info("incomming request: \(req.body)")
        
        let body = try req.content.decode(SGServerDictDTO.self)
        guard let record = try await SGServerSettings.query(on: req.db).filter(\.$key == body.key!).first() else {
            req.logger.error("\(body.key!) has not been updated with value: \(body.value!)")
            let ret: Response = Response()
            ret.status = HTTPResponseStatus.notModified
            ret.body = Response.Body(string: "\(body.key!) has not been updated with value: \(body.value!)")
            return ret
        }
        record.value = body.value ?? ""
        _ = try await record.save(on: req.db)
        
        let ret: Response = Response()
        ret.status = HTTPResponseStatus.accepted
        ret.body = Response.Body(string: "\(body.key!) has been updated with value: \(body.value!)")
        req.logger.info("\(body.key!) has been updated with value: \(body.value!)")
        return ret
    }

}