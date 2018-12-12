public with sharing class Hosp_HospitalEditControllerExtension {
    ApexPages.StandardController standardController;

    public Hosp_HospitalEditControllerExtension(ApexPages.StandardController standardController) {
        this.standardController = standardController;
    }

    public PageReference save() {
        Hospital__c hospital = (Hospital__c) standardController.getRecord();

        List<Hospital__c> hospitals = [SELECT Id, Name FROM Hospital__c WHERE Name = :hospital.Name];

        if (hospitals.isEmpty()) {
            hospital = new Hospital__c(
                    Name = hospital.Name,
                    WWW__c = hospital.WWW__c,
                    City__c = hospital.City__c,
                    Country__c = hospital.Country__c);
            insert hospital;
        } else {
            update hospital;
        }

        return new ApexPages.StandardController(hospital).view();
    }
}