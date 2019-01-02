global with sharing class Hosp_DoctorWrapperForSoap {
    webService String doctorId { get; set; }
    webService String name { get; set; }
    webService String firstName { get; set; }
    webService String country { get; set; }
    webService String city { get; set; }

    public Hosp_DoctorWrapperForSoap(Doctor__c doctor) {
        doctorId = doctor.Id;
        name = doctor.Name;
        firstName = doctor.FirstName__c;
        country = doctor.Country__c;
        city = doctor.City__c;
    }
}
