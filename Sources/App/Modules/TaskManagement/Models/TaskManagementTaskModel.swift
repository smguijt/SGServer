
import Foundation
import Fluent
import Vapor

/* TaskManagementTaskModel
   Main table to create TASKS. Task needs to be assigned to an organization
*/

final class TaskManagementTaskModel: Model, @unchecked Sendable {
    static let schema = "TaskManagementTaskModel"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "task")
    var taskName: String?
    
    @Field(key: "comment")
    var taskDescription: String?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Field(key: "completed")
    var isProcessed: Bool?
    
    @Field(key: "userId")
    var userId: UUID?
    
    @Field(key: "organizationId")
    var organizationId: UUID?
}
