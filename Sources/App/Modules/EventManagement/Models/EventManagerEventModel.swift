import Foundation
import Fluent
import Vapor

/* EventManagementEvent
   table to hold the Event
*/

final class EventManagementEvent: Model, @unchecked Sendable {
    static let schema = "EventManagementEvent"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "eventName")
    var eventName: String?

    @Field(key: "comment")
    var comment: String?

    @Field(key: "startDate")
    var startDate: Date?

    @Field(key: "endDate")
    var endDate: Date?

    @Field(key: "isActive")
    var isActive: Bool?

    @Field(key: "isRegistrationRequired")
    var isRegistrationRequired: Bool?

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

    init(id: UUID? = nil, eventName: String?, comment : String?, startDate: Date?, endDate: Date?, isRegistrationRequired: Bool?, isActive: Bool?) {
        self.id = id
        self.eventName = eventName
        self.comment = comment
        self.startDate = startDate
        self.endDate = endDate
        self.isRegistrationRequired = isRegistrationRequired
        self.isActive = isActive
    } 
}