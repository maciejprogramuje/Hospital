@isTest
public with sharing class Hosp_PiotrDoctorsCalloutTest {

    @isTest
    static void shouldGetDoctorsCalloutTest(){
        //given
        String firstNameDoctor = 'TestDoctorFirstName';
        String lastNameDoctor = 'TestDoctorLastName';
        String countryDoctor = 'TestDoctorCountry';
        String cityDoctor = 'TestDoctorCity';

        Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP doctorsService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();
        Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctor = new Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP();
        doctor.webServiceDoctorLastName = lastNameDoctor;
        doctor.webServiceDoctorFirstName = firstNameDoctor;
        doctor.webServiceDoctorCountry = countryDoctor;
        doctor.webServiceDoctorCity = cityDoctor;

        Hosp_PiotrDoctorsMock mock = new Hosp_PiotrDoctorsMock();
        mock.selectMethod('getDoctor');

        Test.setMock(WebServiceMock.class, mock);

        //when
        List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> results = doctorsService.getDoctors( lastNameDoctor, firstNameDoctor, cityDoctor, countryDoctor);

        //then
        System.assertEquals('TestDoctorId', results.get(0).webServiceDoctorId);
    }

    @isTest
    static void shouldDeleteDoctorsCalloutTest() {
        //given
        Hosp_PiotrDoctorsMock mock = new Hosp_PiotrDoctorsMock();
        mock.selectMethod('deleteDoctor');

        Test.setMock(WebServiceMock.class, mock);

        Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP doctorsService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();

        //when
        List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> results = doctorsService.deleteDoctors(new List<String>{'deleteDoctorId'});

        //then
        System.assertEquals('TestDoctorId', results.get(0).webServiceDoctorId);
    }


    @isTest
    static void shouldInsertDoctorsCalloutTest() {
        //given
        String doctorId;
        String firstNameDoctor = 'TestDoctorFirstNameNew';
        String lastNameDoctor = 'TestDoctorLastNameNew';
        String countryDoctor = 'TestDoctorCountryNew';
        String cityDoctor = 'TestDoctorCityNew';

        Hosp_PiotrDoctorsMock mock = new Hosp_PiotrDoctorsMock();
        mock.selectMethod('insertDoctor');

        Test.setMock(WebServiceMock.class, mock);

        Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP doctorsService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();

        //when
        Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP result = doctorsService.upsertDoctor(doctorId, firstNameDoctor, lastNameDoctor, countryDoctor, cityDoctor);

        //then
        System.assertEquals('TestDoctorFirstNameNew', result.webServiceDoctorFirstName);
    }

    @isTest
    static void shouldUpdateDoctorsCalloutTest() {
        //given
        String doctorId ='TestDoctorId';
        String firstNameDoctor = 'TestDoctorFirstNameUpdate';
        String lastNameDoctor = 'TestDoctorLastName';
        String countryDoctor = 'TestDoctorCountry';
        String cityDoctor = 'TestDoctorCity';

        Hosp_PiotrDoctorsMock mock = new Hosp_PiotrDoctorsMock();
        mock.selectMethod('updateDoctor');

        Test.setMock(WebServiceMock.class, mock);

        Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP doctorsService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();

        //when
        Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP result = doctorsService.upsertDoctor(doctorId, firstNameDoctor, lastNameDoctor, countryDoctor, cityDoctor);

        //then
        System.assertEquals('TestDoctorFirstNameUpdate', result.webServiceDoctorFirstName);
    }
}