@isTest
global with sharing class Hosp_PiotrDoctorsMock implements WebServiceMock {
    public String returnResult = '';

    public void selectMethod(String givenMethod) {
        if (givenMethod.equals('getDoctor')) {
            returnResult = 'getDoctor';
        } else if (givenMethod.equals('insertDoctor')) {
            returnResult = 'insertDoctor';
        } else if (givenMethod.equals('updateDoctor')) {
            returnResult = 'updateDoctor';
        } else if (givenMethod.equals('deleteDoctor')) {
            returnResult = 'deleteDoctor';
        }
    }

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
        Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctor = new Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP();

        doctor.webServiceDoctorId = 'TestDoctorId';
        doctor.webServiceDoctorLastName = 'TestDoctorLastName';
        doctor.webServiceDoctorFirstName = 'TestDoctorFirstName';
        doctor.webServiceDoctorCountry = 'TestDoctorCountry';
        doctor.webServiceDoctorCity = 'TestDoctorCity';

        List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctors = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();
        doctors.add(doctor);

        if (returnResult.equals('getDoctor')) {
            Hosp_soapSforceComSchemasClassHospitalD.getDoctorsResponse_element responseGetElement = new Hosp_soapSforceComSchemasClassHospitalD.getDoctorsResponse_element();
            responseGetElement.result = doctors;

            response.put('response_x', responseGetElement);
        } else if (returnResult.equals('deleteDoctor')) {
            Hosp_soapSforceComSchemasClassHospitalD.deleteDoctorsResponse_element responseDeleteElement = new Hosp_soapSforceComSchemasClassHospitalD.deleteDoctorsResponse_element();
            responseDeleteElement.result = doctors;

            response.put('response_x', responseDeleteElement);
        } else if (returnResult.equals('updateDoctor')) {
            doctor.webServiceDoctorFirstName = 'TestDoctorFirstNameUpdate';

            Hosp_soapSforceComSchemasClassHospitalD.upsertDoctorResponse_element responseInsertElement = new Hosp_soapSforceComSchemasClassHospitalD.upsertDoctorResponse_element();
            responseInsertElement.result = doctor;

            response.put('response_x', responseInsertElement);
        } else if (returnResult.equals('insertDoctor')) {
            Hosp_soapSforceComSchemasClassHospitalD.upsertDoctorResponse_element responseInsertElement = new Hosp_soapSforceComSchemasClassHospitalD.upsertDoctorResponse_element();
            responseInsertElement.result = doctor;

            response.put('response_x', responseInsertElement);
        }
    }
}