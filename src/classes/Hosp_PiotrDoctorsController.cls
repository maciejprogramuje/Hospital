public with sharing class Hosp_PiotrDoctorsController {
    public List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctors { get; set; }
    public Doctor__c doctorToSearch { get; set; }
    public Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP doctorsService { get; set; }

    public Hosp_PiotrDoctorsController() {
        doctorsService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();
        doctors = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();
        doctorToSearch = new Doctor__c();
        //doctorCreateData = new Doctor__c();
        doctorsService.timeout_x = 1000;
        doctorsService.SessionHeader = new Hosp_soapSforceComSchemasClassHospitalD.SessionHeader_element();
        doctorsService.SessionHeader.sessionId = loginToPiotrsClinic();


        List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> results = doctorsService.getDoctors('Jones', 'Koks', '', '');
        System.debug('res='+results.get(0).webServiceDoctorLastName + ' ' + results.get(0).webServiceDoctorFirstName);
    }

    private String loginToPiotrsClinic() {
        try {
            Hosp_partnerSoapSforceCom.Soap partnerSoap = new Hosp_partnerSoapSforceCom.Soap();
            Hosp_partnerSoapSforceCom.LoginResult loginResult = partnerSoap.login('maciej.szymczyk@britenet.com.pl', 'Ulka!2002sjScbwznYDOocJSdloEwSJ8l');
            return loginResult.sessionId;
        } catch (Exception ex) {
            System.debug('Login To Piotrs Clinic Exception >> ' + ex.getMessage());
            return null;
        }
    }

    public void searchDoctors() {
        System.debug('search clicked and N='+doctorToSearch.Name+', FN='+doctorToSearch.FirstName__c+', City='+doctorToSearch.City__c+', Country='+doctorToSearch.Country__c);
    }
}