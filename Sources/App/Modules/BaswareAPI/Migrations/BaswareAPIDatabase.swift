import Fluent
import Foundation

extension DataMigration.v1 { 
        struct CreateDataModelsForModuleBaswareAPI: AsyncMigration {
        func prepare(on db: Database) async throws {
          
        }

        func revert(on db: Database) async throws {

        }
    }

    struct SeedDataModelsForModuleBaswareAPI: AsyncMigration {
        func prepare(on db: Database) async throws {
        }
        
        func revert(on db: Database) async throws {
        }
    }
}