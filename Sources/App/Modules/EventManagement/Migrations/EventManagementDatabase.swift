import Fluent
import Foundation

extension DataMigration.v1 { 

    struct CreateDataModelsForModuleEventManagement: AsyncMigration {
        func prepare(on db: Database) async throws {
           try await db.schema(EventManagementEvent.schema)
                 .id()
                 .field("eventName", .string, .required)
                 .field("comment", .string)
                 .field("isActive", .bool)
                 .field("isRegistrationRequired", .bool)
                 .field("startDate", .datetime)
                 .field("endDate", .datetime)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("orgId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .create()

            try await db.schema(EventManagementSerie.schema)
                 .id()
                 .field("serieName", .string, .required)
                 .field("comment", .string)
                 .field("isActive", .bool)
                 .field("isEventTeamBased", .bool)
                 .field("isRegistrationRequired", .bool)
                 .field("nrOfGamesToPlay", .int16)
                 .field("nrOfPlayersOnLane", .int16)
                 .field("nrOfLanes", .int16)
                 .field("eventId", .uuid)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("orgId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .create()  

            try await db.schema(EventManagementTeam.schema)
                 .id()
                 .field("teamName", .string, .required)
                 .field("comment", .string)
                 .field("isActive", .bool)
                 .field("serieId", .uuid)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("orgId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .create()  

            try await db.schema(EventManagementPlayer.schema)
                 .id()
                 .field("playerName", .string, .required)
                 .field("comment", .string)
                 .field("isActive", .bool)
                 .field("email", .string)
                 .field("serieId", .uuid)
                 .field("teamId", .uuid)
                 .field("eventRegistrationId", .uuid)
                 .field("isMember", .bool)
                 .field("startLane", .int16)
                 .field("Hdp", .int16)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("orgId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .field("NBF_Average", .float)
                 .field("NBF_MembershipNr", .string)
                 .create() 

            try await db.schema(EventManagementScoreCard.schema)
                 .id() 
                 .field("matchDate", .datetime)
                 .field("isActive", .bool)
                 .field("ScoreCardScore", .float)
                 .field("playerId", .uuid, .required)
                 .field("teamId", .uuid, .required)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("orgId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .create()  

            try await db.schema(EventManagementScore.schema)
                 .id() 
                 .field("matchScore", .float)
                 .field("isActive", .bool)
                 .field("lane", .int16)
                 .field("scoreCardId", .uuid, .required)
                 .field("playerId", .uuid, .required)
                 .field("teamId", .uuid, .required)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("orgId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .create()    

            try await db.schema(EventManagementRegistration.schema)
                 .id() 
                 .field("playerName", .string, .required)
                 .field("comment", .string)
                 .field("email", .string)
                 .field("serieId", .uuid)
                 .field("eventId", .uuid)
                 .field("isActive", .bool)
                 .field("isMember", .bool)
                 .field("createdAt", .datetime)
                 .field("updatedAt", .datetime)
                 .field("orgId", .uuid, .required)
                 .field("userId", .uuid, .required)
                 .field("isConfirmed", .bool)
                 .field("confirmationDate", .datetime)
                 .field("confirmationToken", .string)
                 .field("assignedLane", .int16)
                 .create()                                       
        }

        func revert(on db: Database) async throws {
           try await db.schema(EventManagementEvent.schema).delete()
           try await db.schema(EventManagementSerie.schema).delete()
           try await db.schema(EventManagementTeam.schema).delete()
           try await db.schema(EventManagementPlayer.schema).delete()
           try await db.schema(EventManagementScoreCard.schema).delete()
           try await db.schema(EventManagementScore.schema).delete()
           try await db.schema(EventManagementRegistration.schema).delete()
        }
    }

    struct SeedDataModelsForModuleEventManagement: AsyncMigration {
        func prepare(on db: Database) async throws {
        }
        
        func revert(on db: Database) async throws {
        }
        
    }
}