
import Foundation
import Fluent
import Vapor

/* TaskManagementTaskModel
   Main table to create TASKS. Task needs to be assigned to an organization
*/

final class TimeManagementTimeModel: Model, @unchecked Sendable {
    static let schema = "TimeManagementTimeModel"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "startTime")
    var startTime: Date?

    @Field(key: "stopTime")
    var stopTime: Date?
    
    @Field(key: "comment")
    var description: String?
    
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

    init() { }

    init(id: UUID? = nil, startTime: Date, stopTime: Date?, description: String?, isProcessed: Bool? = false, userId: UUID?, organizationId: UUID?) {
        self.id = id
        self.startTime = startTime
        self.stopTime = stopTime
        self.description = description
        self.isProcessed = isProcessed
        self.userId = userId
        self.organizationId = organizationId
    }
}
