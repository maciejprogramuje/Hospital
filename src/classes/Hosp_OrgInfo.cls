public class Hosp_OrgInfo {
    public User currentUser { get; set; }
    public List<User> usersInOrg { get; set; }
    public Integer numberOfActiveUser { get; set; }
    public String orgId { get; set; }
    public String selectedUserId { get; set; }
    public String thisInstancesName { get; set; }
    public String sfdcURL { get; set; }
    public String sessionId { get{return UserInfo.getSessionId();} set; }
    public Integer userLicense { get{return getTotalNumberOfUserLicense();} set; }



    public Hosp_OrgInfo() {
        //Map<Id,List<LoginHistory >> loginDetals = new Map<Id,List<LoginHistory >>();

        getUser();
        usersInOrg = getAllUsersFromOrg();


        /*List<String> listOfUsersIds = new List<String>();
        for(User user : usersInOrg) {
            listOfUsersIds.add(user.Id);
        }*/


        numberOfActiveUser = getAmountActiveUser();
        orgId = getOrgId();
        getOrganizationInfo();
        sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
    }

    public void getUser() {
        String userId = UserInfo.getUserId();
        List<User> currentUsers = [SELECT Id,Name, Address, IsActive, Email FROM User WHERE Id = :userId];
        currentUser = currentUsers.get(0);
    }
    public Integer getAmountActiveUser() {
        List<User> users = [SELECT Id,Name, IsActive, Email FROM User WHERE IsActive = true];
        return users.size();
    }
    public String getOrgId() {
        return UserInfo.getOrganizationId();
    }
    public List<User> getAllUsersFromOrg() {
        List<User> allUsers = [SELECT Id, Name, IsActive, Email FROM User ORDER BY Name];
        return allUsers;
    }
    public void activeUser() {
        for (User selectedUser : usersInOrg) {
            if (selectedUser.Id.equals(selectedUserId)) {
                selectedUser.IsActive = !selectedUser.IsActive;
                update selectedUser;
                break;
            }
        }
        usersInOrg = getAllUsersFromOrg();
        numberOfActiveUser = getAmountActiveUser();
    }
    public void getOrganizationInfo(){
        Organization orgInfo = [SELECT Id, InstanceName FROM Organization];
        thisInstancesName = orgInfo.InstanceName;
    }
    public void resetPassword(){
        System.resetPassword(selectedUserId,true);
    }
    public Integer getTotalNumberOfUserLicense(){
        return [SELECT COUNT() FROM UserLicense];
    }

    public void changeEmail() {
        for (User selectedUser : usersInOrg) {
            if (selectedUser.Id.equals(selectedUserId)) {

                break;
            }
        }
    }

    public void changeEmailResetPassword() {

    }
}



