public with sharing class Hosp_PiotrDoctorsController {
    public List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctors { get; set; }
    public Doctor__c doctorSearchData { get; set; }
    public Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP clinicService { get; set; }

    public Hosp_PiotrDoctorsController() {
        clinicService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();
        doctors = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();
        doctorSearchData = new Doctor__c();
        //doctorCreateData = new Doctor__c();
        clinicService.timeout_x = 1000;
        clinicService.SessionHeader = new Hosp_soapSforceComSchemasClassHospitalD.SessionHeader_element();
        clinicService.SessionHeader.sessionId = loginToPiotrsClinic();


        List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> results = clinicService.getDoctors('Jones', 'Koks', '', '');
        System.debug('res='+results.get(0));
    }


    private String loginToPiotrsClinic() {
        try {
            Hosp_partnerSoapSforceCom.Soap partnerSoap = new Hosp_partnerSoapSforceCom.Soap();

            /*HoMngCustomSetting__c loginCredentials = HoMngCustomSetting__c.getInstance('MGraniczkaClinicLoginCredentials');

            String[] credentials = loginCredentials.Value__c.split(',');*/

            Hosp_partnerSoapSforceCom.LoginResult loginResult = partnerSoap.login('maciej.szymczyk@britenet.com.pl', 'Ulka!2002sjScbwznYDOocJSdloEwSJ8l');

            String sessId = loginResult.sessionId;
            if(sessId!=null){
                System.debug('sessId ok');
            }else {
                System.debug('sessId NOT');
            }


            return sessId;
        } catch (Exception ex) {
            System.debug('Login To Piotrs Clinic Exception >> ' + ex.getMessage());
            return null;
        }
    }

}