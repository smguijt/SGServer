import Vapor
import JWT

struct AuthenticationSessionMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        
        print("[ SESSION MIDDLEWARE ] uri=" + request.url.string)
        
        //request.session.data["name"] = request.parameters.get("value")  // set session value
        //request.session.data["name"] ?? "n/a"  // get session value
        //request.session.destroy() // remove session value
        
        print("[ SESSION MIDDLEWARE ] session [name]: ", request.session.data["name"] ?? "n/a")
        print("[ SESSION MIDDLEWARE ] session [ops]: ", request.session.data["ops"] ?? "n/a")
        
        // determine ops (orgId).
        var orgId:String = request.session.data["ops"] ?? ""
        if orgId == "" {
            orgId = request.query[String.self, at: "ops"] ?? ""
            print("[ SESSION MIDDLEWARE ] check query param ops: \(orgId)")
        } else {
            if (request.url.string == "/?") {
                request.url = "/?ops=\(orgId)"
                print("[ SESSION MIDDLEWARE ] url updated: \(request.url.string)")
                throw Abort.redirect(to: "\(request.url.string)")
            }
        }
        
        if request.session.data["name"] ?? "n/a" == "n/a" {
            print("[ SESSION MIDDLEWARE ] ops=\(orgId)")
            throw Abort.redirect(to: "/view/user/login?ops=\(orgId)")
        }
        
        return try await next.respond(to: request)
    }
}
