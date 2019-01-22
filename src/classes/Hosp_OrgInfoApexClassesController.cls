public with sharing class Hosp_OrgInfoApexClassesController {
    public List<ApexClass> listApexClasses { get; set; }
    public String body { get; set; }
    public String selectedApexId { get; set; }
    public ApexClass apexClass { get; set; }

    public Hosp_OrgInfoApexClassesController() {
        listApexClasses = new List<ApexClass>();
        allApexClasses();
        apexClass = new ApexClass();
    }

    public void allApexClasses() {
        listApexClasses = [SELECT
                ApiVersion,
                Body,
                CreatedById,
                CreatedBy.Name,
                CreatedDate,
                Id,
                LastModifiedById,
                LastModifiedBy.Name,
                LastModifiedDate,
                Name
            FROM ApexClass];
    }

    public void openApexClasses() {
        for (ApexClass oneElement : listApexClasses) {
            if (oneElement.Id.equals(selectedApexId)) {
                apexClass = oneElement;
                break;
            }
        }
    }
}