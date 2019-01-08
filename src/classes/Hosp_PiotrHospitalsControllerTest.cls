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

}


