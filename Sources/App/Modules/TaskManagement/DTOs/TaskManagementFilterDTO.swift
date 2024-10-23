import Fluent
import Vapor

struct TaskManagementFilterDTO: Content {

    let filter: String?
    
    init(filter: String?) {
        self.filter = filter
    }

    init() {
        self.filter = nil
    }
}