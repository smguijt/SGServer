import Foundation
import Fluent
import Vapor

/* EventManagementPlayer
   table to hold the Players for the given Serie or Team. 
*/

final class EventManagementPlayer: Model, @unchecked Sendable {
    static let schema = "EventManagementPlayer"
    
    @ID(key: .id)
    var id: UUID?


    @Field(key: "playerName")
    var playerName: String?

    @Field(key: "comment")
    var comment: String?

    @Field(key: "email")
    var email: String?

    @Field(key: "isActive")
    var isActive: Bool?

    @Field(key: "serieId")
    var serieId: UUID?

     @Field(key: "teamId")
    var teamId: UUID?

     @Field(key: "eventRegistrationId")
    var eventRegistrationId: UUID?

    @Field(key: "isMember")
    var isMember: Bool?

    @Field(key: "startLane")
    var startLane: Int?

    @Field(key: "Hdp")
    var Hdp: Int?

    @Field(key: "userId")
    var userId: UUID?

    @Field(key: "orgId")
    var orgId: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    @Field(key: "NBF_Average")
    var NBF_Average: Float?

    @Field(key: "NBF_MembershipNr")
    var NBF_MembershipNr: String?

    init() {
        
    }
}