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

    init() {
        
    }
}