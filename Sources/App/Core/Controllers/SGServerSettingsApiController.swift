import Fluent
import Vapor

struct SGServerSettingsApiController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let api = routes.grouped("api")
        let settings = api.grouped("settings")
        settings.get(use: self.index2)
        
        let setting = api.grouped("settings")
        setting.get(use: self.index)
        setting.patch(":settingID", use: self.patch)
    }
    
    @Sendable
    func index(req: Request) async throws -> SGServerSettingsDTO {
        req.logger.info("SGServerSettings.Index")
        let mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
        return mySettingsDTO
    }
    
    @Sendable
    func index2(req: Request) async throws -> [SGServerDictDTO] {
        req.logger.info("SGServerSettings.Index2")
        let mySettingsDTO: [SGServerDictDTO] = try await SGServerSettings.query(on: req.db).all().map { $0.toDTO() }
        return mySettingsDTO
    }
    
    @Sendable
    func patch(req: Request) async throws -> SGServerSettingsDTO {
        req.logger.info("SGServerSettingss.Patch")
        let paramId = req.parameters.get("settingID")
        req.logger.info(" -- parameter: \(String(describing: paramId))")
        guard let SGServerSettingsItem = try await SGServerSettings.find(req.parameters.get("settingID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let postedSetting = try req.content.decode(SGServerDictDTO.self)
        SGServerSettingsItem.value = postedSetting.value ?? ""
        try await SGServerSettingsItem.save(on: req.db)
        
        let mySettingsDTO: SGServerSettingsDTO = try await getSettings(req: req)
        return mySettingsDTO
    }
}

