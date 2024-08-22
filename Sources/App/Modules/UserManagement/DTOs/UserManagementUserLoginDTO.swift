
import Foundation

public struct UserManagementUserLoginDTO: Codable {
    
    public var username: String?
    public var password: String?
    public var orgId: String?
    public var hasErrors: Bool?
    public var usernameError: String?
    public var passwordError: String?
    public var errorMessage: String?

    public init(username: String, password: String, hasErrors: Bool?, usernameError: String?, passwordError: String?, errorMessage: String?, orgId: String?) {
        self.hasErrors = hasErrors
        self.errorMessage = errorMessage
        self.username = username
        self.password = password
        self.usernameError = usernameError
        self.passwordError = passwordError
        self.orgId = orgId
    }

    public init(username: String, password: String, orgId: String?) {
        self.hasErrors = false
        self.username = username
        self.password = password
        self.orgId = orgId
    }

    public init() {
        self.hasErrors = false
    }
}


