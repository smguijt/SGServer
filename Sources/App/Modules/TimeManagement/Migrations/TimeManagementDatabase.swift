import Fluent
import Foundation

extension DataMigration.v1 { 
        struct CreateDataModelsForModuleTimeManagement: AsyncMigration {
        func prepare(on db: Database) async throws {
           try await db.schema(TimeManagementTimeModel.schema)
                 .id()
                 .field("startTime", .date, .required)
                 .field("stopTime", .date, .required)
                 .field("comment", .string)
                 .field("completed", .bool)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("organizationId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .create()
        }

        func revert(on db: Database) async throws {
            try await db.schema(TimeManagementTimeModel.schema).delete()
        }
    }

    struct SeedDataModelsForModuleTimeManagement: AsyncMigration {
        func prepare(on db: Database) async throws {
        }
        
        func revert(on db: Database) async throws {
        }
    }
}