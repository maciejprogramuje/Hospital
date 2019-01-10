/**
 * Created by BRITENET on 10.01.2019.
 */

public with sharing class Hosp_HospitalTriggerHandler {
    public static String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';

    @future(Callout=true)
    public static void sendHosp(Set<Id> hospitalsIds) {
        List<Hospital__c> hospitals = [SELECT Id, Name, City__c, Country__c, WWW__c, Street__c, PostalCode__c FROM Hospital__c WHERE Id IN :hospitalsIds];

        List<Hosp_HospitalWrapper> hospitalsInWrapper = new List<Hosp_HospitalWrapper>();
        for (Hospital__c hospital : hospitals) {
            hospitalsInWrapper.add(new Hosp_HospitalWrapper(hospital));
        }

        String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';

        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', body);

        HttpResponse response = http.send(request);
    }


    public static HttpRequest getRequest(String methodType, String urlParams, String body) {
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint + urlParams);
        request.setHeader('Authorization', 'Bearer ' + loginToSecondOrgGetSessionId());
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod(methodType);
        if (body != '') {
            request.setBody(body);
        }
        return request;
    }


    public static String loginToSecondOrgGetSessionId() {


        return '00D1t000000vZ0n!ARcAQFT08b5hYdtLhvZzzT1N0Q6Pak1teHe20a4u9heUF0eg4N2UdojEvkUO5TKfeR2gK0SSbpJZUJX.HhkIEb1RupC6guuE';
    }

    private class Hosp_HospitalWrapper {
        public String name { get; set; }
        public String country { get; set; }
        public String city { get; set; }
        public String postalCode { get; set; }
        public String street { get; set; }

        public Hosp_HospitalWrapper(Hospital__c hospital) {
            name = hospital.Name;
            country = hospital.Country__c;
            city = hospital.City__c;
            postalCode = hospital.PostalCode__c;
            street = hospital.Street__c;
        }
    }
}