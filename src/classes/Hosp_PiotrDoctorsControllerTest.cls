@isTest
public with sharing class Hosp_PiotrDoctorsControllerTest {

    @isTest
    static void shouldGetDoctorsFromPiotr() {
        //given
        Hosp_PiotrDoctorsMock mock = new Hosp_PiotrDoctorsMock();
        mock.selectMethod('getDoctor');
        Test.setMock(WebServiceMock.class, mock);

        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();

        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'TestDoctorLastName';
        doctor.FirstName__c = 'TestDoctorFirstName';
        doctor.Country__c = 'TestDoctorCountry';
        doctor.City__c = 'TestDoctorCity';

        controller.doctorToSearch = doctor;

        List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctors = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();

        //when
        controller.searchDoctors();
        doctors = controller.doctorsResults;

        //then
        System.assertEquals('TestDoctorFirstName', doctors.get(0).webServiceDoctorFirstName);
    }

    @isTest
    static void shouldDeleteDoctorsFromPiotr() {
        //given
        Hosp_PiotrDoctorsMock mock = new Hosp_PiotrDoctorsMock();
        mock.selectMethod('deleteDoctor');
        Test.setMock(WebServiceMock.class, mock);

        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();

        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'TestDoctorLastName';
        doctor.FirstName__c = 'TestDoctorFirstName';
        doctor.Country__c = 'TestDoctorCountry';
        doctor.City__c = 'TestDoctorCity';

        controller.doctorToEdit = doctor;

        List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctors = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();

        //when
        controller.deleteDoctor();
        doctors = controller.deletedDoctorsToTest;

        //then
        System.assertEquals(1, doctors.size());
    }

    @isTest
    static void shouldInsertDoctorsFromPiotr() {
        //given
        Hosp_PiotrDoctorsMock mock = new Hosp_PiotrDoctorsMock();
        mock.selectMethod('insertDoctor');
        Test.setMock(WebServiceMock.class, mock);

        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();

        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'TestDoctorLastName';
        doctor.FirstName__c = 'TestDoctorFirstName';
        doctor.Country__c = 'TestDoctorCountry';
        doctor.City__c = 'TestDoctorCity';

        controller.doctorToInsert = doctor;

        //when
        controller.insertDoctor();

        //then
        System.assertEquals('TestDoctorFirstName', controller.doctorToTest.webServiceDoctorFirstName);
    }

    @isTest
    static void shouldUpdateDoctorsFromPiotr() {
        //given
        Hosp_PiotrDoctorsMock mock = new Hosp_PiotrDoctorsMock();
        mock.selectMethod('updateDoctor');
        Test.setMock(WebServiceMock.class, mock);

        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();

        Doctor__c doctor = new Doctor__c();
        doctor.Name = 'TestDoctorLastName';
        doctor.FirstName__c = 'TestDoctorFirstNameUpdate';
        doctor.Country__c = 'TestDoctorCountry';
        doctor.City__c = 'TestDoctorCity';

        controller.doctorToEdit = doctor;

        //List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctors = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();

        //when
        controller.updateDoctor();

        //then
        System.assertEquals('TestDoctorFirstNameUpdate', controller.doctorToTest.webServiceDoctorFirstName);
    }

    @isTest
    static void shouldOpenDoctorToEdit() {
        //given
        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();

        controller.doctorToEdit = new Doctor__c();

        Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doc = new Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP();
        doc.webServiceDoctorLastName = 'TestDoctorLastName';
        doc.webServiceDoctorFirstName = 'TestDoctorFirstName';
        doc.webServiceDoctorCity = 'TestDoctorCity';
        doc.webServiceDoctorCountry = 'TestDoctorCountry';

        List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctorsResults = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();
        controller.doctorsResults = doctorsResults;
        controller.doctorsResults.add(doc);

        //when
        controller.openDoctorToEdit();

        //then
        System.assertEquals('TestDoctorFirstName', controller.doctorToEdit.FirstName__c);
    }

    @isTest
    static void shouldResetDoctorToInsert() {
        //given
        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();

        //when
        controller.resetDoctorToInsert();

        //then
        System.assertEquals(true, controller.isAnyInsertProblem);
    }

    @isTest
    static void shouldResetDoctorToUpdate() {
        //given
        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();

        //when
        controller.resetDoctorToUpdate();

        //then
        System.assertEquals(true, controller.isAnyUpdateProblem);
    }
}
