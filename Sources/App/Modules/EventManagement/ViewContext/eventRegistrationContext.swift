import Foundation

struct EventRegistrationContext: Encodable {
    var title: String
    var paramId: String?
    var errorMessage: String?
    var successMessage: String?
    var selectedOrgId: String?
    var selectedEventId: String?
    var selectedSerieId: String?
    var settings: SGServerSettingsDTO
}