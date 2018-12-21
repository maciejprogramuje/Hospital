public with sharing class Hosp_WrapperDoctorsCsvImport {
    public String doctorIdWrapper { get; set; }
    public String doctorNameWrapper { get; set; }
    public String doctorFirstNameWrapper { get; set; }
    public String doctorCountryWrapper { get; set; }
    public String doctorCityWrapper { get; set; }
    public Boolean doctorIsSelectedWrapper { get; set; }
    public Boolean doctorIsSelectedBeforeImport { get; set; }
    public Integer doctorInformationAfterImport { get; set; }

    public Hosp_WrapperDoctorsCsvImport(Doctor__c doc) {
        doctorIdWrapper = doc.Id;
        doctorNameWrapper = doc.Name;
        doctorFirstNameWrapper = doc.FirstName__c;
        doctorCountryWrapper = doc.Country__c;
        doctorCityWrapper = doc.City__c;
        doctorIsSelectedWrapper = true;
        doctorInformationAfterImport = 0;
        doctorIsSelectedBeforeImport = false;
    }

    public void setDoctorIsSelectedBeforeImport() {
        this.doctorIsSelectedBeforeImport = true;
    }
}