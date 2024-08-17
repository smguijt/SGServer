import Vapor
import JWT

public struct UserManagementTokenPayloadDTO: JWTPayload {
    
    public func verify(using signer: JWTKit.JWTSigner) throws {
                
    }
    
    public let firstname: String?
    public let lastname: String?
    public let email: String
    public let Id: UUID?
    
    public let status: Int
    public let exp: String
    public let iat: String
    public let aud: String
 }
