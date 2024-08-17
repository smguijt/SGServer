import Vapor
import JWT

struct AuthenticationTokenMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {

        print("[ TOKEN MIDDLEWARE ] uri=" + request.url.string)
        // Headers: Authorization: Bearer .....
        guard let authorization = request.headers.bearerAuthorization else {
            print("[ TOKEN MIDDLEWARE ] bearer token not provided!")
            throw Abort(.unauthorized)
        }
        print("[ TOKEN MIDDLEWARE ] uri=" + authorization.token)
        
        return try await next.respond(to: request)
    }
}

