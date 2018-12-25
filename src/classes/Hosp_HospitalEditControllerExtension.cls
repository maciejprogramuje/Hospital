public with sharing class Hosp_HospitalEditControllerExtension {
    ApexPages.StandardController standardController;
    public String hospitalIdCurrent { get; set; }

    public Hosp_HospitalEditControllerExtension(ApexPages.StandardController standardController) {
        this.standardController = standardController;
        hospitalIdCurrent = standardController.getRecord().Id;
    }

    public PageReference save() {
        Hospital__c hospital = (Hospital__c) standardController.getRecord();

        List<Hospital__c> hospitals = [SELECT Id, Name FROM Hospital__c WHERE Name = :hospital.Name];

        if (hospitals.isEmpty()) {
            hospital = new Hospital__c(
                    Name = hospital.Name,
                    WWW__c = hospital.WWW__c,
                    City__c = hospital.City__c,
                    Country__c = hospital.Country__c,
                    PostalCode__c = hospital.PostalCode__c,
                    Street__c = hospital.Street__c,
                    Master_Unit__c = hospital.Master_Unit__c);
            insert hospital;
        } else {
            update hospital;
        }

        return new ApexPages.StandardController(hospital).view();
    }

    public List<SelectOption> getMasterUnits() {
        List<SelectOption> options = new List<SelectOption>();
        for(Hospital__c h : [SELECT Id, Name FROM Hospital__c WHERE Id <> :hospitalIdCurrent]) {
            options.add(new SelectOption(h.Id, h.Name));
        }
        options.add(new SelectOption('', Label.None_Option));
        options.sort();
        return options;
    }
}