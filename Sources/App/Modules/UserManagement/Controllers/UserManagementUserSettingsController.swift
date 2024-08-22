import Fluent
import Vapor
import Leaf

struct UserManagementUserSettingsController: RouteCollection {
    
    /* ROUTES */
    func boot(routes: RoutesBuilder) throws {
        let pg = routes.grouped("view").grouped("user")

        pg.get("settings", use: self.renderUserSettings)
        pg.post("settings", use: self.updateUserSetting)
    }

    @Sendable
    func renderUserSettings(req: Request) async throws -> View {

        req.logger.info("calling UserManagement.usersettings")
        
        var userIdString = try? req.query.get(String.self, at: "userid")
        if (userIdString == nil) {
            userIdString = req.session.data["sgsoftware_systemuser"] ?? ""
            req.logger.info("session sgsoftware_systemuser found: \(userIdString ?? "")")
        }
        let userId = UUID(uuidString: userIdString ?? "") ?? UUID()
        print("DEBUG INFO: UserManagement.usersettings.GET.userId -> \(userIdString!) --> \(userId.uuidString)")

        var mySettingsDTO: SGServerSettingsDTO = try await getUserSettings(req: req, userId: userId)
        mySettingsDTO.ShowToolbar = true
        req.logger.info("userSettings retrieved: \(mySettingsDTO)")
        return try await req.view.render("UserManagementUserSettings", BaseContext(title: "UserManagement", settings: mySettingsDTO))
    }
    
    @Sendable
    func updateUserSetting(_ req: Request) async throws -> Response {

        req.logger.info("calling UserManagement.usersettings POST")
        req.logger.info("incomming request: \(req.body)")

        let body: UserManagementDictDTO = try req.content.decode(UserManagementDictDTO.self)
        guard let record: UserManagementUserSettingsModel = try await UserManagementUserSettingsModel
            .query(on: req.db)
            .filter(\.$key == body.key!)
            .filter(\.$userId == body.userId!)
            .first() 
        else {

            /* no value found for given record so create */
            let newRecord: UserManagementUserSettingsModel = 
                UserManagementUserSettingsModel(key: body.key!, value: body.value!, userId: body.userId!)
            _ = try await newRecord.save(on: req.db)


            let ret: Response = Response()
            ret.status = HTTPResponseStatus.created
            ret.body = Response.Body(string: "\(body.key!) has been created with value: \(body.value!)")
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