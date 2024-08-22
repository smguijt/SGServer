import Foundation

struct TabBaseContext: Encodable {
    var title: String
    var paramId: String?
    var errorMessage: String?
    var settings: SGServerSettingsDTO
    var tabIndicator: String?
}
