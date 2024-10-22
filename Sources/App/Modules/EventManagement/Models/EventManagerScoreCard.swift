import Foundation
import Fluent
import Vapor

/* EventManagementScoreCard
   table to hold the ScoreCard for the given Serie, Team or Player.
*/

final class EventManagementScoreCard: Model, @unchecked Sendable {
    static let schema = "EventManagementScoreCard"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "matchDate")
    var matchDate: Date?

    @Field(key: "isActive")
    var isActive: Bool?

    @Field(key: "ScoreCardScore")
    var ScoreCardScore: Int?

    @Field(key: "playerId")
    var playerId: UUID?

    @Field(key: "scoreCardId")
    var scoreCardId: UUID?

     @Field(key: "teamId")
    var teamId: UUID?

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