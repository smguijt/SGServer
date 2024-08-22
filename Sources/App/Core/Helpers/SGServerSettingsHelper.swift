import Foundation
import Fluent
import Vapor

func getSettings(req: Request) async throws -> SGServerSettingsDTO {
    /* retrieve settings */
    var mySettingDTO: SGServerSettingsDTO = SGServerSettingsDTO()
    _ = try await SGServerSettings.query(on: req.db).all().compactMap{ setting in
        
            /* map ID */
            //mySettingDTO.ID = setting.id
            if let sessionName = req.session.data["sgsoftware_system_user"] {
                mySettingDTO.userId = UUID(sessionName)
            }
        
            /* ShowToolbar*/
            if setting.key == SGServerEnumSettings.ShowToolbar.rawValue {
                mySettingDTO.ShowToolbar = Bool(setting.value.lowercased()) ?? false
            }
        
            /* ShowMessages*/
            if setting.key == SGServerEnumSettings.ShowMessages.rawValue {
                mySettingDTO.ShowMessages = Bool(setting.value.lowercased()) ?? false
            }
        
            /* ShowApps*/
            if setting.key == SGServerEnumSettings.ShowApps.rawValue {
                mySettingDTO.ShowApps = Bool(setting.value.lowercased()) ?? false
            }
            
            /* ShowNotifications*/
            if setting.key == SGServerEnumSettings.ShowNotifications.rawValue {
                mySettingDTO.ShowNotifications = Bool(setting.value.lowercased()) ?? false
            }
            
            /* ShowUpdates*/
            if setting.key == SGServerEnumSettings.ShowUpdates.rawValue {
                mySettingDTO.ShowUpdates = Bool(setting.value.lowercased()) ?? false
            }

            /* ShowUserBox*/
            if setting.key == SGServerEnumSettings.ShowUserBox.rawValue {
                mySettingDTO.ShowUserBox = Bool(setting.value.lowercased()) ?? false
            }
            
            /* ShowUseOAUTH02 */
            if setting.key == SGServerEnumSettings.UseOAUTH02.rawValue {
                mySettingDTO.UseOAUTH02 = Bool(setting.value.lowercased()) ?? false
            }
        }
    
    return mySettingDTO
}

