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
    static void shouldGetHospitals_HospitalsExist() {
        //given
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/Hospital__c/';
        request.httpMethod = 'GET';

        request.addParameter('Name', 'TestHospitalName%');
        request.addParameter('Country__c', 'PL');
        request.addParameter('City__c', 'Warszawa');
        request.addParameter('PostalCode__c', '03-738');
        request.addParameter('Street__c', 'Kijowska');

        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        List<HospitalWrapperForRest> results = Hosp_RestForHospitals.getHospitals();
        Test.stopTest();

        //then
        System.assertEquals(2, results.size());
    }

    @isTest
    static void shouldGetHospitals_HospitalsNotExist() {
        //given
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/Hospital__c/';
        request.httpMethod = 'GET';

        request.addParameter('Name', 'TestHospitalName1111');
        request.addParameter('Country__c', 'PL');
        request.addParameter('City__c', 'Warszawa');
        request.addParameter('PostalCode__c', '03-738');
        request.addParameter('Street__c', 'Kijowska');

        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        List<HospitalWrapperForRest> results = Hosp_RestForHospitals.getHospitals();
        Test.stopTest();

        //then
        System.assertEquals(0, results.size());
    }

    @isTest
    static void shouldGetHospitals_WrongParams() {
        //given
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/Hospital__c/';
        request.httpMethod = 'GET';

        request.addParameter('NNNNName', 'TestHospitalName%');

        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        List<HospitalWrapperForRest> results = Hosp_RestForHospitals.getHospitals();
        Test.stopTest();

        //then
        System.assertEquals(0, results.size());
    }

    @isTest
    static void shouldUpsertHospital_Insert() {
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
            List<HospitalWrapperForRest> results = Hosp_RestForHospitals.upsertHospitals(hospitals);
        Test.stopTest();

        //then
        System.assertEquals(2, results.size());
    }

    @isTest
    static void shouldUpsertHospital_UpdateTrueHospitals() {
        //given
        List<Hospital__c> rawHospitals = [SELECT Id,
                Name,
                City__c,
                Country__c,
                PostalCode__c,
                Street__c
            FROM Hospital__c
            WHERE Name LIKE 'TestHospitalName%'];

        List<HospitalWrapperForRest> hospitals = new List<HospitalWrapperForRest>();
        for(Hospital__c rawHospital : rawHospitals) {
            rawHospital.Name = rawHospital.Name + '_Updated';
            hospitals.add(new HospitalWrapperForRest(rawHospital));
        }

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/Hospital__c/';
        request.httpMethod = 'PUT';

        RestContext.request = request;
        RestContext.response = response;

        //when
        Test.startTest();
        List<HospitalWrapperForRest> results = Hosp_RestForHospitals.upsertHospitals(hospitals);
        Test.stopTest();

        //then
        Boolean isUpdated = true;
        for (HospitalWrapperForRest result : results) {
            if(!result.Name.contains('_Updated')) {
                isUpdated = false;
            }
        }
        System.assertEquals(true, isUpdated);
    }

    @isTest
    static void shouldDeleteHospitals_TrueIds() {
        //given
        List<Hospital__c> hospitalsIds = [SELECT Id FROM Hospital__c WHERE Name LIKE 'TestHospitalName%'];
        List<HospitalWrapperForRest> results = new List<HospitalWrapperForRest>();

        if(!hospitalsIds.isEmpty()) {
            RestRequest request = new RestRequest();
            RestResponse response = new RestResponse();
            request.requestURI = '/services/apexrest/Hospital__c/' + hospitalsIds[0].Id + ',' + hospitalsIds[1].Id;
            request.httpMethod = 'DELETE';

            RestContext.request = request;
            RestContext.response = response;

            //when
            Test.startTest();
            results = Hosp_RestForHospitals.deleteHospitals();
            Test.stopTest();
        }

        //then
        System.assertEquals(2, results.size());
    }

    @isTest
    static void shouldDeleteHospitals_FakeIds() {
        //given
        List<Hospital__c> hospitalsIds = [SELECT Id FROM Hospital__c WHERE Name LIKE 'TestHospitalName1111'];
        List<HospitalWrapperForRest> results = new List<HospitalWrapperForRest>();

        if(!hospitalsIds.isEmpty()) {
            RestRequest request = new RestRequest();
            RestResponse response = new RestResponse();
            request.requestURI = '/services/apexrest/Hospital__c/' + hospitalsIds[0].Id + ',' + hospitalsIds[1].Id;
            request.httpMethod = 'DELETE';

            RestContext.request = request;
            RestContext.response = response;

            //when
            Test.startTest();
            results = Hosp_RestForHospitals.deleteHospitals();
            Test.stopTest();
        }

        //then
        System.assertEquals(0, results.size());
    }
}