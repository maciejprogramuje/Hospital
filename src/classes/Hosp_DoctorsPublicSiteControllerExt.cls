public with sharing class Hosp_DoctorsPublicSiteControllerExt {
    public List<Doctor__c> randomDoctors { get; set; }
    Integer numberOfRandomDoctors;

    
    public Hosp_DoctorsPublicSiteControllerExt(ApexPages.StandardController controller) {
        numberOfRandomDoctors = 10;

        randomDoctors = generateRandomDoctors();
    }

    private List<Doctor__c> generateRandomDoctors() {
        Integer count = [SELECT COUNT() FROM Doctor__c];
        Integer rand = Math.floor(Math.random() * count).intValue();
        List<Doctor__c> doctors = [SELECT FirstLastName__c,
                Email__c,
                City__c,
                Country__c
            FROM Doctor__c
            LIMIT :numberOfRandomDoctors
            OFFSET :rand];

        return doctors;
    }
}