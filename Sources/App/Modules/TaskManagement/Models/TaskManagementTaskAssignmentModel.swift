
import Foundation
import Fluent
import Vapor

/* TaskManagementTaskAssignmentModel
   table to hold TASKS assignments table.
    When a task is created it can be assigned to an user
    user needs to be of course within the same organization of the created task
*/

final class TaskManagementTaskAssignmentModel: Model, @unchecked Sendable {
    static let schema = "TaskManagementTaskAssignmentModel"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "assignedUserId")
    var assignedUserId: UUID?
    
    @Field(key: "comment")
    var comment: String?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Field(key: "dueAt")
    var dueAt: Date?
    
    @Field(key: "taskId")
    var taskId: UUID?
    
    @Field(key: "userId")
    var userId: UUID?
}
