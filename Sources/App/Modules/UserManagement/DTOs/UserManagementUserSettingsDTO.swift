import Fluent
import Vapor

struct UserManagementUserSettingsDTO: Content {
    
    //var ID: UUID?
    var ShowMessages: Bool
    //var ShowApps: Bool
    var ShowNotifications : Bool
    var ShowUpdates: Bool
    var userId: UUID
    var UseOAUTH02: Bool
    var ClientId: String
    var ClientSecret: String

    init(//ID: UUID?,
         userId: UUID,
         ShowMessages: Bool = false,
         //ShowApps: Bool = false,
         ShowNotifications: Bool = false,
         ShowUpdates: Bool = false,
         UseOAUTH02: Bool = false,
         ClientId: String = "",
         ClientSecret: String = "") {
        
        //self.ID = ID
        self.ShowMessages = ShowMessages
        //self.ShowApps = ShowApps
        self.ShowNotifications = ShowNotifications
        self.ShowUpdates = ShowUpdates
        self.userId = userId
        self.UseOAUTH02 = UseOAUTH02
        self.ClientId = ClientId
        self.ClientSecret = ClientSecret
    }
  
}

