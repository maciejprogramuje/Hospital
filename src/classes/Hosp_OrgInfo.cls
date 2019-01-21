public class Hosp_OrgInfo {
    public User currentUser { get; set; }

    public User selectedUser { get; set; }
    public List<LoginHistory> loginHistory { get; set; }
    public String activateDeactivate { get; set; }

    public List<User> usersInOrg { get; set; }
    public Integer numberOfActiveUser { get; set; }
    public String orgId { get; set; }
    public String selectedUserId { get; set; }
    public String thisInstancesName { get; set; }
    public String sfdcURL { get; set; }
    public String sessionId {
        get {
            return UserInfo.getSessionId();
        }
        set;
    }
    public Integer userLicense {
        get {
            return getTotalNumberOfUserLicense();
        }
        set;
    }


    public Hosp_OrgInfo() {
        getUser();
        usersInOrg = getAllUsersFromOrg();

        numberOfActiveUser = getAmountActiveUser();
        orgId = getOrgId();
        getOrganizationInfo();
        sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';

        loginHistory = new List<LoginHistory>();
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

    public void generateUserAndHistory() {
        for (User user : usersInOrg) {
            if (user.Id.equals(selectedUserId)) {
                selectedUser = user;
                break;
            }
        }

        if (selectedUser.IsActive) {
            activateDeactivate = 'Deactivate';
        } else {
            activateDeactivate = 'Activate';
        }

        loginHistory = [
                SELECT
                        UserId,
                        LoginTime,
                        SourceIp,
                        Platform,
                        Browser
                FROM LoginHistory
                WHERE UserId = :selectedUserId
                AND LoginTime = LAST_N_DAYS:30
                ORDER BY LoginTime DESC
                LIMIT 1000
        ];
    }

    public void activeUser() {
        System.debug('activeUser clicked');
        System.debug('selectedUser=' + selectedUser);

        selectedUser.IsActive = !selectedUser.IsActive;
        update selectedUser;

        usersInOrg = getAllUsersFromOrg();
        numberOfActiveUser = getAmountActiveUser();
    }

    public void getOrganizationInfo() {
        Organization orgInfo = [SELECT Id, InstanceName FROM Organization];
        thisInstancesName = orgInfo.InstanceName;
    }

    public void resetPassword() {
        System.resetPassword(selectedUserId, true);
    }

    public Integer getTotalNumberOfUserLicense() {
        return [SELECT COUNT() FROM UserLicense];
    }

    public void changeEmail() {
        /*for (User selectedUser : usersInOrg) {
            if (selectedUser.Id.equals(selectedUserId)) {

                break;
            }
        }*/
    }

    public void changeEmailResetPassword() {

    }

    public class UserWrapper {
        public User userWrapp { get; set; }
        public List<LoginHistory> loginHistoryWrapp { get; set; }

        public UserWrapper(User u, List<LoginHistory> lh) {
            userWrapp = u;
            loginHistoryWrapp = lh;
        }
    }
}


