import Foundation
import Fluent
import Vapor

/* TaskManagementTaskItemModel
   table to hold additional information about the task.
    Data should be presented in a list that can be checked off
*/

final class TaskManagementTaskItemModel: Model, @unchecked Sendable {
    static let schema = "TaskManagementTaskItemModel"
    
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
    
    @Field(key: "completed")
    var isProcessed: Bool?
    
    @Field(key: "dueAt")
    var dueAt: Date?
}
