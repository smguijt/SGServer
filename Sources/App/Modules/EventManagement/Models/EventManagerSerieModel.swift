import Foundation
import Fluent
import Vapor

/* EventManagementSerie
   table to hold the Serie for the given Event. 
*/

final class EventManagementSerie: Model, @unchecked Sendable {
    static let schema = "EventManagementSerie"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "serieName")
    var serieName: String?

    @Field(key: "comment")
    var comment: String?

    @Field(key: "isActive")
    var isActive: Bool?

    @Field(key: "isEventTeamBased")
    var isEventTeamBased: Bool?

    @Field(key: "isRegistrationRequired")
    var isRegistrationRequired: Bool?

    @Field(key: "nrOfGamesToPlay")
    var nrOfGamesToPlay: Int?

    @Field(key: "nrOfPlayersOnLane")
    var nrOfPlayersOnLane: Int?

    @Field(key: "nrOfLanes")
    var nrOfLanes: Int?

    @Field(key: "eventId")
    var eventId: UUID?

    @Field(key: "userId")
    var userId: UUID?

    @Field(key: "orgId")
    var orgId: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    init() {
        
    }
}