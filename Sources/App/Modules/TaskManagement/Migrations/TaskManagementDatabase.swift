import Fluent
import Foundation
import Vapor

extension DataMigration.v1 {
        struct CreateDataModelsForModuleTaskManagement: AsyncMigration {
        func prepare(on db: Database) async throws {
            try await db.schema(TaskManagementTaskModel.schema)
                 .id()
                 .field("task", .string, .required)
                 .field("comment", .string)
                 .field("completed", .bool)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("organizationId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .create()
            
            try await db.schema(TaskManagementTaskHistoryModel.schema)
                 .id()
                 .field("comment", .string)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("taskId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .create()
            
            try await db.schema(TaskManagementTaskAssignmentModel.schema)
                 .id()
                 .field("assignedUserId", .uuid, .required)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("comment", .string)
                 .field("dueAt", .datetime, .required)
                 .field("taskId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .create()
            
            try await db.schema(TaskManagementTaskItemModel.schema)
                 .id()
                 .field("comment", .string)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("dueAt", .datetime)
                 .field("taskId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .field("completed", .bool)
                 .create()
            
            try await db.schema(TaskManagementTaskComments.schema)
                 .id()
                 .field("comment", .string, .required)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("taskId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .create()
        }

        func revert(on db: Database) async throws {
            try await db.schema(TaskManagementTaskModel.schema).delete()
            try await db.schema(TaskManagementTaskHistoryModel.schema).delete()
            try await db.schema(TaskManagementTaskAssignmentModel.schema).delete()
            try await db.schema(TaskManagementTaskItemModel.schema).delete()
            try await db.schema(TaskManagementTaskComments.schema).delete()
        }
    }
    
    

    struct SeedDataModelsForModuleTaskManagement: AsyncMigration {
        func prepare(on db: Database) async throws {
        }
        
        func revert(on db: Database) async throws {
        }
        
    }
}
