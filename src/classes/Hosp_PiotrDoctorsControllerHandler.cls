public with sharing class Hosp_PiotrDoctorsControllerHandler {
    public Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP doctorsService { get; set; }

    public Hosp_PiotrDoctorsControllerHandler() {
        doctorsService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();
        doctorsService.timeout_x = 1000;
        doctorsService.SessionHeader = new Hosp_soapSforceComSchemasClassHospitalD.SessionHeader_element();
    }

    public void generateDoctorServiceFromCache() {
        doctorsService.SessionHeader.sessionId = (String)Cache.Session.get('local.Hosp.sessionIdToPiotrek');
    }

    public void generateDoctorServiceFromSoap() {
        String sessionId = loginToPiotrGetSessionId();
        Cache.Session.put('local.Hosp.sessionIdToPiotrek', sessionId);

        doctorsService.SessionHeader.sessionId = sessionId;
    }

    private static String loginToPiotrGetSessionId() {
        if(!Test.isRunningTest()) {
            try {
                Hosp_partnerSoapSforceCom.Soap partnerSoap = new Hosp_partnerSoapSforceCom.Soap();
                Hosp_partnerSoapSforceCom.LoginResult loginResult = partnerSoap.login(Label.Hosp_login_to_Piotr, Label.Hosp_password_to_Piotr);
                return loginResult.sessionId;
            } catch (Exception ex) {
                System.debug(ex.getMessage());
                return null;
            }
        }
        return null;
    }

}