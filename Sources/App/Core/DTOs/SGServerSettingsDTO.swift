import Fluent
import Vapor

struct SGServerSettingsDTO: Content {
    
    //var ID: UUID?
    var ShowToolbar: Bool
    var ShowMessages: Bool
    var ShowApps: Bool
    var ShowNotifications : Bool
    var ShowUpdates: Bool
    var ShowUserBox: Bool
    var userId: UUID?
    var UseOAUTH02: Bool
    var ClientId: String?
    var ClientSecret: String?
    var SidebarToggleState: Bool?
    
    init(//ID: UUID? = nil,
         ShowToolbar: Bool = false,
         ShowMessages: Bool = false,
         ShowApps: Bool = false,
         ShowNotifications: Bool = false,
         ShowUpdates: Bool = false,
         ShowUserBox: Bool = false,
         userId: UUID? = nil,
         UseOAUTH02: Bool = false,
         ClientId: String? = nil,
         ClientSecret: String? = nil,
         SidebarToggleState: Bool? = false) {
        
        //self.ID = ID
        self.ShowToolbar = ShowToolbar
        self.ShowMessages = ShowMessages
        self.ShowApps = ShowApps
        self.ShowNotifications = ShowNotifications
        self.ShowUpdates = ShowUpdates
        self.ShowUserBox = ShowUserBox
        self.userId = userId
        self.UseOAUTH02 = UseOAUTH02
        self.ClientId = ClientId
        self.ClientSecret = ClientSecret
        self.SidebarToggleState = SidebarToggleState
    }
}

