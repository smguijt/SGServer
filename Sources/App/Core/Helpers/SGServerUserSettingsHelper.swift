import Foundation
import Fluent
import Vapor

func getUserSettings(req: Request, userId: UUID) async throws -> SGServerSettingsDTO {
     
    var myUserSettingDTO: SGServerUserSettingsDTO = SGServerUserSettingsDTO(userId: userId)

     _ = try await SGServerUserSettings
            .query(on: req.db)
            .filter(\.$userId == userId)
            .all()
            .compactMap { setting in
                
                /* map ID */
                //myUserSettingDTO.ID = setting.id
                myUserSettingDTO.userId = userId
                
                /* ShowMessages*/
                if setting.key == SGServerEnumSettings.ShowMessages.rawValue {
                    myUserSettingDTO.ShowMessages = Bool(setting.value.lowercased()) ?? false
                }

                /* ShowApps*/
                if setting.key == SGServerEnumSettings.ShowApps.rawValue {
                    myUserSettingDTO.ShowApps = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ShowNotifications*/
                if setting.key == SGServerEnumSettings.ShowNotifications.rawValue {
                    myUserSettingDTO.ShowNotifications = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ShowUpdates*/
                if setting.key == SGServerEnumSettings.ShowUpdates.rawValue {
                    myUserSettingDTO.ShowUpdates = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ShowUseOAUTH02 */
                if setting.key == SGServerEnumSettings.UseOAUTH02.rawValue {
                    myUserSettingDTO.UseOAUTH02 = Bool(setting.value.lowercased()) ?? false
                }
                
                /* ClientId */
                if setting.key == SGServerEnumSettings.ClientId.rawValue {
                    myUserSettingDTO.ClientId = String(setting.value)
                }
                
                /* ClientSecret */
                if setting.key == SGServerEnumSettings.ClientSecret.rawValue {
                    myUserSettingDTO.ClientSecret = String(setting.value)
                }

                return myUserSettingDTO
            }

    
    let mySystemSettings: SGServerSettingsDTO = try await getSettings(req: req)
    let mySettingDTO: SGServerSettingsDTO = SGServerSettingsDTO(ShowToolbar: mySystemSettings.ShowToolbar,
                                                ShowMessages: myUserSettingDTO.ShowMessages,
                                                ShowApps: myUserSettingDTO.ShowApps,
                                                ShowNotifications: myUserSettingDTO.ShowNotifications,
                                                ShowUpdates: myUserSettingDTO.ShowUpdates,
                                                ShowUserBox: mySystemSettings.ShowUserBox,
                                                userId: mySystemSettings.userId,
                                                UseOAUTH02: mySystemSettings.UseOAUTH02,
                                                ClientId: myUserSettingDTO.ClientId,
                                                ClientSecret: myUserSettingDTO.ClientSecret)

    return mySettingDTO
 }

