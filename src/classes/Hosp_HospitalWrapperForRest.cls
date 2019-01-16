global with sharing class Hosp_HospitalWrapperForRest {
    webService String hospitalId { get; set; }
    webService String externalId { get; set; }
    webService String name { get; set; }
    webService String country { get; set; }
    webService String city { get; set; }
    webService String postalCode { get; set; }
    webService String street { get; set; }
    webService Boolean status { get; set; }

    global Hosp_HospitalWrapperForRest() {

    }

    global Hosp_HospitalWrapperForRest(Hospital__c hospital) {
        hospitalId = hospital.Id;
        externalId = hospital.ExternalId__c;
        name = hospital.Name;
        country = hospital.Country__c;
        city = hospital.City__c;
        postalCode = hospital.PostalCode__c;
        street = hospital.Street__c;
    }
}