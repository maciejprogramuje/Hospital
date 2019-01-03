public with sharing class Hosp_PiotrDoctorsController {
    public Doctor__c doctorToSearch { get; set; }
    public Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP doctorsService { get; set; }
    public List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctorsResults { get; set; }

    public Hosp_PiotrDoctorsController() {
        doctorsService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();
        doctorToSearch = new Doctor__c();
        doctorsService.timeout_x = 1000;
        doctorsService.SessionHeader = new Hosp_soapSforceComSchemasClassHospitalD.SessionHeader_element();
        doctorsService.SessionHeader.sessionId = loginToPiotr();

        doctorsResults = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();
    }

    public void searchDoctors() {
        doctorsResults = doctorsService.getDoctors(doctorToSearch.Name, doctorToSearch.FirstName__c, doctorToSearch.City__c, doctorToSearch.Country__c);

        if(doctorsResults != null) {
            System.debug('doctorsResults.size='+doctorsResults.size());

            for(Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctorResult : doctorsResults) {
                System.debug('search clicked and N='+doctorResult.webServiceDoctorLastName
                        +', FN='+doctorResult.webServiceDoctorFirstName
                        +', City='+doctorResult.webServiceDoctorCity
                        +', Country='+doctorResult.webServiceDoctorCountry);
            }
        }
    }

    public void editDoctor() {

    }

    public void deleteDoctor() {

    }

    private String loginToPiotr() {
        try {
            Hosp_partnerSoapSforceCom.Soap partnerSoap = new Hosp_partnerSoapSforceCom.Soap();
            Hosp_partnerSoapSforceCom.LoginResult loginResult = partnerSoap.login('maciej.szymczyk@britenet.com.pl', 'Ulka!2002sjScbwznYDOocJSdloEwSJ8l');
            return loginResult.sessionId;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            return null;
        }
    }
}