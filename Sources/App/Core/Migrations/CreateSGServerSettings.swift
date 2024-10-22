import Fluent
import Foundation

extension DataMigration.v1 {

    struct CreateSGServerSettings: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("SGServerSettings")
                .id()
                .field("key", .string, .required)
                .field("value", .string, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("SGServerSettings").delete()
        }
    }

    struct SeedSGServerSettings: AsyncMigration {
        func prepare(on db: Database) async throws {
            /* create entry */
            let settingShowToolbar: SGServerSettings = SGServerSettings(key: SGServerEnumSettings.ShowToolbar.rawValue, value: "false")
            try await settingShowToolbar.create(on: db)
            
            /* create entry */
            let settingShowMessages = SGServerSettings(key: SGServerEnumSettings.ShowMessages.rawValue, value: "false")
            try await settingShowMessages.create(on: db)
            
            /* create entry */
            let settingShowApps = SGServerSettings(key: SGServerEnumSettings.ShowApps.rawValue, value: "false")
        try await settingShowApps.create(on: db)
            
            /* create entry */
            let settingShowNotifications = SGServerSettings(key: SGServerEnumSettings.ShowNotifications.rawValue, value: "false")
            try await settingShowNotifications.create(on: db)
                
            /* create entry */
            let settingShowUpdates = SGServerSettings(key: SGServerEnumSettings.ShowUpdates.rawValue, value: "false")
            try await settingShowUpdates.create(on: db)

            /* create entry */
            let settingShowUserBox = SGServerSettings(key: SGServerEnumSettings.ShowUserBox.rawValue, value: "false")
            try await settingShowUserBox.create(on: db)
                
            /* create entry */
            let settingUseOAUTH02 = SGServerSettings(key: SGServerEnumSettings.UseOAUTH02.rawValue, value: "false")
            try await settingUseOAUTH02.create(on: db)

            /* create entry ( true = collapse, false = expand) */
            let SidebarToggleState: SGServerSettings = SGServerSettings(key: SGServerEnumSettings.SidebarToggleState.rawValue, value: "false")
            try await SidebarToggleState.create(on: db)
        }

        
        
        func revert(on db: Database) async throws {
            try await SGServerSettings.query(on: db).delete()
        }
        
    }
}
