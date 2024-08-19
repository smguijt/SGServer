import Fluent
import Vapor

func CreateDatabaseModels(_ app: Application) throws {

    app.logger.info("create database table: settings")
    app.migrations.add(DataMigration.v1.CreateSGServerSettings())

    //app.logger.info("create database table: user settings")
    //app.migrations.add(DataMigration.v1.CreateSGServerUserSettings())

    app.logger.info("create database table: for extention modules")
    app.migrations.add(DataMigration.v1.CreateDataModelsForModuleEventManagement())
    app.migrations.add(DataMigration.v1.CreateDataModelsForModuleTaskManagement())
    app.migrations.add(DataMigration.v1.CreateDataModelsForModuleTimeManagement())
    app.migrations.add(DataMigration.v1.CreateDataModelsForModuleUserManagement())
}

func SeedDatabaseModels(_ app: Application) throws {
    app.migrations.add(DataMigration.v1.SeedSGServerSettings())
    //app.migrations.add(DataMigration.v1.SeedSGServerUserSettings())
    app.migrations.add(DataMigration.v1.SeedDataModelsForModuleEventManagement())
    app.migrations.add(DataMigration.v1.SeedDataModelsForModuleTaskManagement())
    app.migrations.add(DataMigration.v1.SeedDataModelsForModuleTimeManagement())
    app.migrations.add(DataMigration.v1.SeedDataModelsForModuleUserManagement())
}
