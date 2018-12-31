global with sharing class HospitalWrapperForRest {
    public String hospitalId { get; set; }
    public String name { get; set; }
    public String country { get; set; }
    public String city { get; set; }
    public String postalCode { get; set; }
    public String street { get; set; }

    global HospitalWrapperForRest(Hospital__c hospital) {
        hospitalId = hospital.Id;
        name = hospital.Name;
        country = hospital.Country__c;
        city = hospital.City__c;
        postalCode = hospital.PostalCode__c;
        street = hospital.Street__c;
    }
}