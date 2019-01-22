public with sharing class Hosp_OrgInfoJobsController {
    public List<AsyncApexJob> jobsList { get; set; }

    public Hosp_OrgInfoJobsController() {
        getAllApexJobs();
    }

    public void getAllApexJobs() {
        String futureString = 'Future';
        jobsList = [SELECT
                ID,
                JobItemsProcessed,
                TotalJobItems,
                Status,
                JobType,
                CreatedDate,
                MethodName,
                ApexClass.Name
            FROM AsyncApexJob
            WHERE JobType =:futureString
            ORDER BY CreatedDate DESC];
    }

}