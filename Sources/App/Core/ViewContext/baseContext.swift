import Foundation

struct BaseContext: Encodable {
    var title: String
    var paramId: String?
    var errorMessage: String?
    var settings: SGServerSettingsDTO
}
