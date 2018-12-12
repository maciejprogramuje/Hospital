public with sharing class Hosp_DoctorViewControllerExtension {
    public List<Contract__c> contracts { get; set; }
    public String contractId { get; set; }
    public String doctorId { get; set; }

    public Hosp_DoctorViewControllerExtension(ApexPages.StandardController standardController) {
        doctorId = standardController.getRecord().Id;
        getContracts();
    }

    public void dismiss() {
        Contract__c contract = [SELECT Id, StartDate__c, EndDate__c FROM Contract__c WHERE Id = :contractId];
        if (contract.StartDate__c > Date.today()) {
            delete contract;
        } else if (contract.StartDate__c < Date.today() && contract.EndDate__c > Date.today()) {
            contract.EndDate__c = Date.today();
            update contract;
        }

        getContracts();
    }

    private void getContracts() {
        String doctorContractsQuery = 'SELECT Id, Name, StartDate__c, EndDate__c, Doctor__r.Name, Doctor__r.FirstName__c, Doctor__r.Id, Hospital__r.Name FROM Contract__c WHERE Doctor__c = \'' + doctorId +'\'';
        contracts = Database.query(doctorContractsQuery);
    }
}