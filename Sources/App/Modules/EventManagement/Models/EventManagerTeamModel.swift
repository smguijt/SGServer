import Foundation
import Fluent
import Vapor

/* EventManagementTeam
   table to hold the Teams for the given Serie.
*/

final class EventManagementTeam: Model, @unchecked Sendable {
    static let schema = "EventManagementTeam"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "teamName")
    var teamName: String?

    @Field(key: "comment")
    var comment: String?

    @Field(key: "isActive")
    var isActive: Bool?

    @Field(key: "serieId")
    var serieId: UUID?

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