import Foundation
import Fluent
import Vapor

/* EventManagementScoreCard
   table to hold the Scores for a given scoreCard.
*/

final class EventManagementScore: Model, @unchecked Sendable {
    static let schema = "EventManagementScore"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "matchScore")
    var matchScore: Float?

    @Field(key: "isActive")
    var isActive: Bool?

    @Field(key: "lane")
    var lane: Int?

    @Field(key: "playerId")
    var playerId: UUID?

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