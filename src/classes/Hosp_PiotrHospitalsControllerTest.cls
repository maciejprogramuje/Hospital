@isTest
public class Hosp_PiotrHospitalsControllerTest {

    @isTest
    static void shouldInsertAndGetHospitalsCallout() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');

        Hosp_PiotrHospitalSingleMock fakeHospital = new Hosp_PiotrHospitalSingleMock(
                200,
                'Complete',
                '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospital);
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/?Name=HospitalTest&City__c=Lublin&Country__c=PL', fakeHospital);

        HttpCalloutMock multiCalloutMock = new Hosp_PiotrHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();

        Hospital__c hospital = new Hospital__c(Name = 'HospitalTest', City__c = 'Lublin', Country__c = 'PL');

        controller.hospitalToEdit = hospital;
        controller.hospitalToSearch = hospital;

        //when
        controller.upsertHospital();
        controller.searchHospitals();

        //then
        System.assertEquals(false, controller.isAnyUpsertProblem);
        System.assertEquals('HospitalTest', controller.hospitalsResults.get(0).name);
    }

    @isTest
    static void shouldDeleteHospitalsCallout() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');

        Hosp_PiotrHospitalSingleMock fakeHospital = new Hosp_PiotrHospitalSingleMock(
                200,
                'Complete',
                '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();

        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospital);
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/?Name=HospitalTest&City__c=Lublin&Country__c=PL', fakeHospital);
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/deleteId', fakeHospital);

        HttpCalloutMock multiCalloutMock = new Hosp_PiotrHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        Hospital__c hospital = new Hospital__c(Name = 'HospitalTest', City__c = 'Lublin', Country__c = 'PL');
        controller.hospitalToEdit = hospital;
        controller.hospitalToSearch = hospital;

        //when
        controller.upsertHospital();
        controller.hospitalToEditId = 'deleteId';
        controller.deleteHospital();
        controller.searchHospitals();

        //then
        System.assertEquals(false, controller.isAnyProblemWithDelete);
    }

    @isTest
    static void shouldResetHospitalToUpsert() {
        //given
        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();

        //when
        controller.resetHospitalToUpsert();

        //then
        System.assertEquals(true, controller.isAnyUpsertProblem);
    }

    @isTest
    static void shouldOpenHospitalToEdit() {
        //given
        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        Hospital__c hospital = new Hospital__c();
        controller.hospitalsResults.add(new Hosp_HospitalWrapperForRest(hospital));
        controller.hospitalToEditId = hospital.Id;

        //when
        controller.openHospitalToEdit();

        //then
        System.assertEquals(controller.hospitalToEditId, controller.hospitalToEdit.Id);
    }

    @isTest
    static void shouldSortByName() {
        //given
        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        controller.hospitalsResults = new List<Hosp_HospitalWrapperForRest>();
        controller.hospitalsResults.add(new Hosp_HospitalWrapperForRest());

        //when
        controller.sortByName();
        controller.sortAsc = false;
        controller.sortByName();

        //then
        System.assertEquals(1, controller.hospitalsResults.size());
    }

    @isTest
    static void shouldSortByCity() {
        //given
        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        controller.hospitalsResults = new List<Hosp_HospitalWrapperForRest>();
        controller.hospitalsResults.add(new Hosp_HospitalWrapperForRest());

        //when
        controller.sortByCity();
        controller.sortAsc = false;
        controller.sortByCity();

        //then
        System.assertEquals(1, controller.hospitalsResults.size());
    }

    @isTest
    static void shouldSortByCountry() {
        //given
        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        controller.hospitalsResults = new List<Hosp_HospitalWrapperForRest>();
        controller.hospitalsResults.add(new Hosp_HospitalWrapperForRest());

        //when
        controller.sortByCountry();
        controller.sortAsc = false;
        controller.sortByCountry();

        //then
        System.assertEquals(1, controller.hospitalsResults.size());
    }
}




