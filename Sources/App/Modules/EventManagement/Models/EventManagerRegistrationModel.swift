import Foundation
import Fluent
import Vapor

/* EventManagementRegistration
   table to hold the user registration for an event
*/

final class EventManagementRegistration: Model, @unchecked Sendable {
    static let schema = "EventManagementRegistration"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "playerName")
    var playerName: String?

    @Field(key: "comment")
    var comment: String?

    @Field(key: "email")
    var email: String?

    @Field(key: "eventId")
    var eventId: UUID?

     @Field(key: "serieId")
    var serieId: UUID?
    
    @Field(key: "isActive")
    var isActive: Bool?

    @Field(key: "isMember")
    var isMember: Bool?

    @Field(key: "userId")
    var userId: UUID?

    @Field(key: "orgId")
    var orgId: UUID?

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    @Field(key: "isConfirmed")
    var isConfirmed: Bool?

    @Field(key: "confirmationDate")
    var confirmationDate: Date?

    @Field(key: "confirmationToken")
    var confirmationToken: String?

    @Field(key: "assignedLane")
    var assignedLane: Int?


    init() {
        
    }

    
}