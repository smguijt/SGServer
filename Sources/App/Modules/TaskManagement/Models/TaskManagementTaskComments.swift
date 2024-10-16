import Foundation
import Fluent
import Vapor

/* TaskManagementTaskComments
   table to hold additional comments for the giventask.
*/

final class TaskManagementTaskComments: Model, @unchecked Sendable {
    static let schema = "TaskManagementTaskComments"
    
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

