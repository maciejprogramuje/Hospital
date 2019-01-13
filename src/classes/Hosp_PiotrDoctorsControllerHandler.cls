public with sharing class Hosp_PiotrDoctorsControllerHandler {
    public Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP doctorsService { get; set; }

    public Hosp_PiotrDoctorsControllerHandler() {
        generateDoctorService();
    }

    private void generateDoctorService() {
        doctorsService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();
        doctorsService.timeout_x = 1000;
        doctorsService.SessionHeader = new Hosp_soapSforceComSchemasClassHospitalD.SessionHeader_element();
        doctorsService.SessionHeader.sessionId = Hosp_Utils.loginToPiotrGetSessionId();
    }

}