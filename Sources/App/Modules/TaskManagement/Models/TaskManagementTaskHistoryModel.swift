
import Foundation
import Fluent
import Vapor

/* TaskManagementTaskHistoryModel
   table to hold TASKS history table. When entry is created or updated an insertjes needs to be added to this table
*/

final class TaskManagementTaskHistoryModel: Model, @unchecked Sendable {
    static let schema = "TaskManagementTaskHistoryModel"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "comment")
    var comment: String?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Field(key: "taskId")
    var taskId: UUID?
    
    @Field(key: "userId")
    var userId: UUID?
}
