global with sharing class Hosp_DoctorWrapperForSoap {
    public String doctorId { get; set; }
    public String name{ get; set; }
    public String firstName { get; set; }
    public String country { get; set; }
    public String city { get; set; }

    public Hosp_DoctorWrapperForSoap(Doctor__c doctor) {
        doctorId = doctor.Id;
        name = doctor.Name;
        firstName = doctor.FirstName__c;
        country = doctor.Country__c;
        city = doctor.City__c;
    }
}