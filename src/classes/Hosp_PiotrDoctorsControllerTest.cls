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

        controller.doctorToEdit = doctor;

        //when
        controller.upsertDoctor();

        //then
        System.assertEquals('TestDoctorFirstName', controller.doctorToTest.webServiceDoctorFirstName);
    }

    @isTest
    static void shouldNotInsertDoctorsFromPiotr() {
        //given
        Hosp_PiotrDoctorsMock mock = new Hosp_PiotrDoctorsMock();
        mock.selectMethod('insertDoctor');
        Test.setMock(WebServiceMock.class, mock);

        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();

        controller.doctorToEdit = null;

        //when
        controller.upsertDoctor();

        //then
        System.assertEquals(null, controller.doctorToTest);
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

        //when
        controller.upsertDoctor();

        //then
        System.assertEquals('TestDoctorFirstNameUpdate', controller.doctorToTest.webServiceDoctorFirstName);
    }

    @isTest
    static void shouldNotUpdateDoctorsFromPiotr() {
        //given
        Hosp_PiotrDoctorsMock mock = new Hosp_PiotrDoctorsMock();
        mock.selectMethod('updateDoctor');
        Test.setMock(WebServiceMock.class, mock);

        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();

        controller.doctorToEdit = null;

        //when
        controller.upsertDoctor();

        //then
        System.assertEquals(null, controller.doctorToTest);
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
    static void shouldResetDoctorToUpsert() {
        //given
        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();

        //when
        controller.resetDoctorToUpsert();

        //then
        System.assertEquals(true, controller.isAnyUpsertProblem);
    }

    @isTest
    static void shouldSortByName() {
        //given
        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();
        controller.doctorsResults = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();
        controller.doctorsResults.add(new Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP());

        //when
        controller.sortByName();
        controller.sortAsc = false;
        controller.sortByName();

        //then
        System.assertEquals(1, controller.doctorsResults.size());
    }

    @isTest
    static void shouldSortByCity() {
        //given
        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();
        controller.doctorsResults = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();
        controller.doctorsResults.add(new Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP());

        //when
        controller.sortByCity();
        controller.sortAsc = false;
        controller.sortByCity();

        //then
        System.assertEquals(1, controller.doctorsResults.size());
    }

    @isTest
    static void shouldSortByFirstName() {
        //given
        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();
        controller.doctorsResults = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();
        controller.doctorsResults.add(new Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP());

        //when
        controller.sortByFirstName();
        controller.sortAsc = false;
        controller.sortByFirstName();

        //then
        System.assertEquals(1, controller.doctorsResults.size());
    }

    @isTest
    static void shouldSortByCountry() {
        //given
        Hosp_PiotrDoctorsController controller = new Hosp_PiotrDoctorsController();
        controller.doctorsResults = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();
        controller.doctorsResults.add(new Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP());

        //when
        controller.sortByCountry();
        controller.sortAsc = false;
        controller.sortByCountry();

        //then
        System.assertEquals(1, controller.doctorsResults.size());
    }

}
