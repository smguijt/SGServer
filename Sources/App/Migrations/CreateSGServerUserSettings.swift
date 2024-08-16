import Fluent
import Foundation

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

struct SeedTaskManagementUserSettings: AsyncMigration {
    func prepare(on db: Database) async throws {
    }
    
    func revert(on db: Database) async throws {
        try await SGServerUserSettings.query(on: db).delete()
    }
    
}
