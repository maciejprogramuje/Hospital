public with sharing class Hosp_HospitalViewControllerExtension {
    public List<Contract__c> contracts { get; set; }
    public String hospitalIdCurrent { get; set; }
    public String contractIdCurrent { get; set; }

    public Hosp_HospitalViewControllerExtension(ApexPages.StandardController standardController) {
        hospitalIdCurrent = standardController.getRecord().Id;
        getContracts();
    }

    public void getContracts() {
        contracts = [SELECT Id,
                Name,
                StartDate__c,
                EndDate__c,
                Doctor__r.Name,
                Doctor__r.FirstName__c,
                Doctor__r.FirstLastName__c,
                Doctor__r.Id,
                Hospital__r.Name
        FROM Contract__c
        WHERE Hospital__c = :hospitalIdCurrent
        ORDER BY StartDate__c];
    }

    public void dismiss() {
        Contract__c contract = [SELECT Id, StartDate__c, EndDate__c FROM Contract__c WHERE Id = :contractIdCurrent];
        if (contract.StartDate__c > Date.today()) {
            delete contract;
        } else if (contract.StartDate__c <= Date.today() && contract.EndDate__c >= Date.today()) {
            contract.EndDate__c = Date.today();
            contract.isFinished__c = true;
            update contract;
        }

        getContracts();
    }
}