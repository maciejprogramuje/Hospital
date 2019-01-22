public class Hosp_OrgInfo {
    public User currentUser { get; set; }

    public User selectedUser { get; set; }
    public List<LoginHistory> loginHistory { get; set; }
    public String activateDeactivate { get; set; }
    public String emailField { get; set; }

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
        emailField = '';

        for (User user : usersInOrg) {
            if (user.Id.equals(selectedUserId)) {
                selectedUser = user;
                break;
            }
        }

        if (selectedUser.IsActive) {
            activateDeactivate = Label.Hosp_Deactivate;
        } else {
            activateDeactivate = Label.Hosp_Activate;
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
        if (String.isNotBlank(emailField)) {
            selectedUser.Email = emailField;
            update selectedUser;

            usersInOrg = getAllUsersFromOrg();
        }
    }

    public void changeEmailResetPassword() {
        changeEmail();
        if (String.isNotBlank(emailField)) {
            resetPassword();
        }
    }

    public PageReference goToApexPage() {
        PageReference apexClassesPage = Page.Hosp_OrgInfoApexClasses;
        apexClassesPage.getParameters().put('pageReferenceURL', ApexPages.currentPage().getUrl());
        apexClassesPage.setRedirect(true);
        return apexClassesPage;
    }

    public PageReference goToVisualforcePage() {
        PageReference apexClassesPage = Page.Hosp_OrgInfoPages;
        apexClassesPage.getParameters().put('pageReferenceURL', ApexPages.currentPage().getUrl());
        apexClassesPage.setRedirect(true);
        return apexClassesPage;
    }

    public PageReference goToJobsPage() {
        PageReference jobsPage = Page.Hosp_OrgInfoJobs;
        jobsPage.getParameters().put('pageReferenceURL', ApexPages.currentPage().getUrl());
        jobsPage.setRedirect(true);
        return jobsPage;
    }
}



