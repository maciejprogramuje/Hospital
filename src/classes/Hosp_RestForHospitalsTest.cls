@isTest
private class Hosp_RestForHospitalsTest {

    @testSetup
    static void setup() {
        List<Hospital__c> testHospitals = new List<Hospital__c>();

        for (Integer i = 1; i <= 2; i++) {
            testHospitals.add(new Hospital__c(Name = 'TestHospitalName' + i,
                    Country__c = 'PL',
                    City__c = 'Warszawa',
                    PostalCode__c = '03-738',
                    Street__c = 'Kijowska'));
        }
        insert testHospitals;
    }

    @isTest
    static void shouldGetHospitals() {
        //given
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/Hospital__c/';
        request.httpMethod = 'GET';

        request.addParameter('Name', 'TestHospitalName%');

        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
            List<Hospital__c> results = Hosp_RestForHospitals.getHospitals();
        Test.stopTest();

        //then
        System.assertEquals(2, results.size());
    }


    @isTest
    static void shouldUpsertHospital() {
        //given
        List<HospitalWrapperForRest> hospitals = new List<HospitalWrapperForRest>();

        for (Integer i = 3; i <= 4; i++) {
            hospitals.add(new HospitalWrapperForRest(new Hospital__c(Name = 'TestHospitalName' + i,
                    Country__c = 'PL',
                    City__c = 'Warszawa',
                    PostalCode__c = '03-738',
                    Street__c = 'Kijowska')));
        }

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/Hospital__c/';
        request.httpMethod = 'PUT';

        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
            List<String> results = Hosp_RestForHospitals.upsertHospitals(hospitals);
        Test.stopTest();

        //then
        System.assertEquals(2, results.size());
    }


    @isTest
    static void shouldDeleteHospitals() {
        //given
        List<Hospital__c> hospitalsIds = [SELECT Id FROM Hospital__c WHERE Name LIKE 'TestHospitalName%'];

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/Hospital__c/' + hospitalsIds[0] + ',' + hospitalsIds[1];
        request.httpMethod = 'GET';

        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
            List<Hospital__c> results = Hosp_RestForHospitals.getHospitals();
        Test.stopTest();

        //then
        System.assertEquals(2, results.size());
    }
}