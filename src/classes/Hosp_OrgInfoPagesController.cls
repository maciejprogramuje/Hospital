public with sharing class Hosp_OrgInfoPagesController {
    public List<ApexPage> listVisualForcePages { get; set; }
    public String selectedPageId { get; set; }
    public ApexPage apexPage { get; set; }

    public Hosp_OrgInfoPagesController() {
        allVisualForcePages();
        apexPage = new ApexPage();
    }

    public void allVisualForcePages() {
        listVisualForcePages = [SELECT
                ApiVersion,
                Markup,
                CreatedBy.Name,
                CreatedDate,
                Id,
                LastModifiedBy.Name,
                LastModifiedDate,
                Name
            FROM ApexPage];
    }

    public void openPageClasses() {
        for (ApexPage oneElement : listVisualForcePages) {
            if (oneElement.Id.equals(selectedPageId)) {
                apexPage = oneElement;
                break;
            }
        }
    }
}