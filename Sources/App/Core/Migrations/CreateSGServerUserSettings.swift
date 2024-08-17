import Fluent
import Foundation

extension DataMigration.v1 {

    struct CreateSGServerUserSettings: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("SGServerUserSettings")
                .id()
                .field("key", .string, .required)
                .field("value", .string, .required)
                .field("userId", .uuid )
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("SGServerUserSettings").delete()
        }
    }

    struct SeedSGServerUserSettings: AsyncMigration {
        func prepare(on db: Database) async throws {
        }
        
        func revert(on db: Database) async throws {
            try await SGServerUserSettings.query(on: db).delete()
        }
        
    }
}