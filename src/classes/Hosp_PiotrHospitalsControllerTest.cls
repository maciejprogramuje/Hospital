/**
 * Created by BRITENET on 08.01.2019.
 */

@isTest
public class Hosp_PiotrHospitalsControllerTest {

    @isTest
    static void shouldGetHospitals() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');
        Hosp_PiotrHospitalSingleMock fakeHospitalResp = new Hosp_PiotrHospitalSingleMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/?Name=HospitalTest&City__c=Lublin&Country__c=PL', fakeHospitalResp);

        HttpCalloutMock multiCalloutMock = new Hosp_PiotrHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        controller.hospitalToSearch = new Hospital__c(Name = 'HospitalTest', Country__c = 'PL', City__c = 'Lublin');

        //when
        controller.searchHospitals();

        //then
        List<Hosp_HospitalWrapperForRest> hospitals = controller.hospitalsResults;
        System.assertEquals('HospitalTest', hospitals.get(0).name);
    }

    @isTest
    static void shouldInsertHospitals() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');
        Hosp_PiotrHospitalSingleMock fakeHospitalResp = new Hosp_PiotrHospitalSingleMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospitalResp);

        HttpCalloutMock multiCalloutMock = new Hosp_PiotrHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        controller.hospitalToInsert = new Hospital__c(Name = 'HospitalTest', Country__c = 'PL', City__c = 'Lublin');

        //when
        controller.insertHospital();

        //then
        System.assertEquals(false, controller.isAnyInsertProblem);
    }

    @isTest
    static void shouldNotInsertHospitals() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');
        Hosp_PiotrHospitalSingleMock fakeHospitalResp = new Hosp_PiotrHospitalSingleMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospitalResp);

        HttpCalloutMock multiCalloutMock = new Hosp_PiotrHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        controller.hospitalToInsert = null;

        //when
        controller.insertHospital();

        //then
        System.assertEquals(true, controller.isAnyInsertProblem);
    }

    @isTest
    static void shouldUpdateHospitals() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');
        Hosp_PiotrHospitalSingleMock fakeHospitalResp = new Hosp_PiotrHospitalSingleMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospitalResp);

        HttpCalloutMock multiCalloutMock = new Hosp_PiotrHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        controller.hospitalToEdit = new Hospital__c(Name = 'HospitalTest', Country__c = 'PL', City__c = 'Lublin');

        //when
        controller.updateHospital();

        //then
        System.assertEquals(false, controller.isAnyUpdateProblem);
    }

    @isTest
    static void shouldNotUpdateHospitals() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');
        Hosp_PiotrHospitalSingleMock fakeHospitalResp = new Hosp_PiotrHospitalSingleMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospitalResp);

        HttpCalloutMock multiCalloutMock = new Hosp_PiotrHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        controller.hospitalToEdit = null;

        //when
        controller.updateHospital();

        //then
        System.assertEquals(true, controller.isAnyUpdateProblem);
    }

    @isTest
    static void shouldDeleteHospitals() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');
        Hosp_PiotrHospitalSingleMock fakeHospitalResp = new Hosp_PiotrHospitalSingleMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/hospitalIdToDelete', fakeHospitalResp);

        HttpCalloutMock multiCalloutMock = new Hosp_PiotrHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        controller.hospitalToEditId = 'hospitalIdToDelete';
        controller.hospitalToEdit = new Hospital__c(Name = 'HospitalTest', Country__c = 'PL', City__c = 'Lublin');

        //when
        controller.deleteHospital();

        //then
        System.assertEquals(false, controller.isAnyProblemWithDelete);
    }

    @isTest
    static void shouldResetHospitalToInsert() {
        //given
        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();

        //when
        controller.resetHospitalToInsert();

        //then
        System.assertEquals(true, controller.isAnyInsertProblem);
    }

    @isTest
    static void shouldResetHospitalToUpdate() {
        //given
        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();

        //when
        controller.resetHospitalToUpdate();

        //then
        System.assertEquals(true, controller.isAnyUpdateProblem);
    }

    @isTest
    static void shouldOpenHospitalToEdit() {
        //given
        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        //controller.hospitalsResults = new List<Hosp_HospitalWrapperForRest>();
        Hospital__c hospital = new Hospital__c();
        controller.hospitalsResults.add(new Hosp_HospitalWrapperForRest(hospital));
        controller.hospitalToEditId = hospital.Id;

        //when
        controller.openHospitalToEdit();

        //then
        System.assertEquals(controller.hospitalToEditId, controller.hospitalToEdit.Id);
    }


    /*@isTest
    static void shouldInsertAndGetHospitalsCallout() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');
        Hospital_MaciejHospitalSingleRequestMock fakeHospitalInsert = new Hospital_MaciejHospitalSingleRequestMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);
        Hospital_MaciejHospitalSingleRequestMock fakeHospitalGet = new Hospital_MaciejHospitalSingleRequestMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospitalInsert);
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/?Name=HospitalTest&City__c=Lublin&Country__c=PL', fakeHospitalGet);
        HttpCalloutMock multiCalloutMock =
                new Hospital_MaciejHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Hospital_MaciejHospitalsController controller = new Hospital_MaciejHospitalsController();
        String name = 'HospitalTest';
        String country = 'PL';
        String city = 'Lublin';
        Hospital__c hospital = new Hospital__c(Name = name, City__c = city, Country__c = country);
        controller.hospitalCreateData = hospital;
        controller.hospitalSearchData = hospital;
        //when
        controller.insertHospital();
        controller.searchHospitals();
        //then
        System.assertEquals(1, controller.hospitalsFromMaciej.size());
    }
    @isTest
    static void shouldDeleteHospitalsCallout() {
        //given
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');
        Hospital_MaciejHospitalSingleRequestMock fakeHospitalRespond = new Hospital_MaciejHospitalSingleRequestMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/', fakeHospitalRespond);
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/?Name=HospitalTest&City__c=Lublin&Country__c=PL', fakeHospitalRespond);
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/deleteId', fakeHospitalRespond);
        HttpCalloutMock multiCalloutMock =
                new Hospital_MaciejHospitalsMultiMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Hospital_MaciejHospitalsController controller = new Hospital_MaciejHospitalsController();
        String id = 'deleteId';
        String name = 'HospitalTest';
        String country = 'PL';
        String city = 'Lublin';
        Hospital__c hospital = new Hospital__c(Name = name, City__c = city, Country__c = country);
        controller.hospitalCreateData = hospital;
        controller.hospitalSearchData = hospital;
        controller.hospitalToEditId = id;
        //when
        controller.insertHospital();
        controller.searchHospitals();
        controller.hospitalToEditId = id;
        controller.deleteHospital();
        //then
        System.assertEquals(1, controller.hospitalsFromMaciej.size());
    }*/
}




