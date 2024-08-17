import Fluent
import Foundation

extension DataMigration.v1 { 
        struct CreateDataModelsForModuleTaskManagement: AsyncMigration {
        func prepare(on database: Database) async throws {
           
        }

        func revert(on database: Database) async throws {
           
        }
    }

    struct SeedDataModelsForModuleTaskManagement: AsyncMigration {
        func prepare(on db: Database) async throws {
        }
        
        func revert(on db: Database) async throws {
        }
        
    }
}