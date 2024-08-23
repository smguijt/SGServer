
enum UserManagementRoleEnum: String {
    case admin /* admin role, admin access to specified organizations  */
    case user /* user role, , user access to specified organizations */
    case superuser /* super user role, access to all organizations */
    case system /* background worker role, access to specified organizations */
    case api /* allow data retrieval via REST */
    case UserManagement /* module access */
    case TimeManagement  /* module access */
    case EventManagement /* module access */
    case TaskManagement /* module access */
}
