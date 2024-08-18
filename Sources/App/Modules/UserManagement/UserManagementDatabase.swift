import Fluent
import Vapor
import Foundation


extension DataMigration.v1 { 
        struct CreateDataModelsForModuleUserManagement: AsyncMigration {
        func prepare(on db: Database) async throws {
           try await db.schema(UserManagementAccountModel.schema)
                .id()
                .field("email", .string, .required)
                .field("password", .string, .required)
                .field("createdAt", .datetime)
                .field("updatedAt", .datetime)
                .unique(on: "email")
                .create()
            
            try await db.schema(UserManagementDetailModel.schema)
                .id()
                .field("prefix", .string)
                .field("firstname", .string)
                .field("lastname", .string)
                .field("postfix", .string)
                .field("birthdate", .datetime)
                .field("createdAt", .datetime)
                .field("active", .bool)
                .field("avatar", .string)
                .field("userId", .uuid)
                .unique(on: "userId")
                .create()
            
            try await db.schema(UserManagementAddressModel.schema)
                .id()
                .field("steet", .string)
                .field("housno", .string)
                .field("postalcode", .string)
                .field("city", .string)
                .field("country", .string)
                .field("telephone", .string)
                .field("mobile", .string)
                .field("createdAt", .datetime)
                .field("updatedAt", .datetime)
                .field("userId", .uuid)
                .create()
            
            try await db.schema(UserManagementRoleModel.schema)
                .id()
                .field("role", .string)
                .field("createdAt", .datetime)
                .field("updatedAt", .datetime)
                .field("userId", .uuid)
                .create()
        }

        func revert(on db: Database) async throws {
            try await db.schema(UserManagementAccountModel.schema).delete()
            try await db.schema(UserManagementDetailModel.schema).delete()
            try await db.schema(UserManagementAddressModel.schema).delete()  
            try await db.schema(UserManagementRoleModel.schema).delete()
        }
    }

    struct SeedDataModelsForModuleUserManagement: AsyncMigration {
        func prepare(on db: Database) async throws {
            /* create user */
            let email = "root@localhost.com"
            let password = "ChangeMe!"
            let user = 
             UserManagementAccountModel(email: email,
                                        password: try Bcrypt.hash(password))
            try await user.create(on: db)
            
            /* create user role */
            let userRole1 = UserManagementRoleModel(role:UserManagementRoleEnum.admin.rawValue, createdAt: nil, updatedAt: nil, userId:user.id)
            try await userRole1.create(on: db)
            
            /* create user role */
            let userRole2 = UserManagementRoleModel(role:UserManagementRoleEnum.user.rawValue, createdAt: nil, updatedAt: nil, userId:user.id)
            try await userRole2.create(on: db)
        }
        
        func revert(on db: Database) async throws {
            try await UserManagementAccountModel.query(on: db).delete()
        }
        
    }
}