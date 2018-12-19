public with sharing class Hosp_DoctorsPublicSiteControllerExt {
    public List<Doctor__c> randomDoctors { get; set; }
    Integer numberOfRandomDoctors;


    public Hosp_DoctorsPublicSiteControllerExt(ApexPages.StandardController controller) {
        numberOfRandomDoctors = 10;
        randomDoctors = generateRandomDoctors();
    }

    private List<Doctor__c> generateRandomDoctors() {
        Integer numberOfAllDoctors = [SELECT COUNT() FROM Doctor__c];

        List<Doctor__c> doctors = new List<Doctor__c>();

        for (Integer i = 0; i < numberOfRandomDoctors;) {
            Integer rand = Math.floor(Math.random() * numberOfAllDoctors).intValue() ;

            List<Doctor__c> doctorsHandler = [SELECT FirstLastName__c,
                    Email__c,
                    City__c,
                    Country__c
                FROM Doctor__c
                LIMIT :(numberOfRandomDoctors - i) OFFSET :rand];
            
            doctors.addAll(doctorsHandler);

            i = doctors.size();
        }

        return doctors;
    }
}