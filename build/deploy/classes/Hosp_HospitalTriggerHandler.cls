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

        System.debug('body='+body);

        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', body);

        HttpResponse response = http.send(request);

        System.debug('response='+response.getStatusCode());
    }





    public static HttpRequest getRequest(String methodType, String urlParams, String body) {
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint + urlParams);
        request.setHeader('Authorization', 'Bearer ' + loginToFirstOrgGetSessionId());
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod(methodType);
        if (body != '') {
            request.setBody(body);
        }
        return request;
    }

    public static String loginToFirstOrgGetSessionId() {
        String username = 'maciej.szymczyk@britenet.com.pl.dev';
        String password = 'Ulka@2002q9k94fNBLasceuStSg3Z69Us';
        String ClientId = '3MVG9fTLmJ60pJ5InwHdKeAk5APGVSVg_li6LxfLJBR7_3sPECDShp1WB4iAPueUXfrEiSJA84cpqOcOD2xPn';
        String ClientSecret = '6095802832678610274';


        //todo - access token

        return Hosp_Utils.getAccessToken(username, password, ClientId, ClientSecret);
    }


    private class Hosp_HospitalWrapper {
        public String id { get; set; }
        public String name { get; set; }
        public String country { get; set; }
        public String city { get; set; }
        public String postalCode { get; set; }
        public String street { get; set; }

        public Hosp_HospitalWrapper(Hospital__c hospital) {
            id = hospital.Id;
            name = hospital.Name;
            country = hospital.Country__c;
            city = hospital.City__c;
            postalCode = hospital.PostalCode__c;
            street = hospital.Street__c;
        }
    }
}