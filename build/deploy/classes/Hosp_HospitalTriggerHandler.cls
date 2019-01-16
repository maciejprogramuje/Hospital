/**
 * Created by BRITENET on 10.01.2019.
 */

public with sharing class Hosp_HospitalTriggerHandler {
    public static String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';

    @future(Callout=true)
    public static void sendHosp(String hospitalsJson) {
        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', hospitalsJson);

        HttpResponse response = http.send(request);

        Hosp_HospitalLogCallout__c logCallout = new Hosp_HospitalLogCallout__c(
                RequestBody__c = request.getBody(),
                ResponseBody__c = response.getBody(),
                External_Id__c = '',
                CreateDate__c = Datetime.now(),
                OperationType__c = 'Send hospital',
                Status__c = String.valueOf(response.getStatusCode())
        );

        insert logCallout;
    }

    @future(Callout=true)
    public static void deleteHosp(List<String> hospitalsIds) {
        String hospitalToDeleteId;

        for (String hospId : hospitalsIds) {
            hospitalToDeleteId = hospId;
            break;
        }

        Http http = new Http();
        HttpRequest request = getRequest('DELETE', hospitalToDeleteId, '');
        HttpResponse response = http.send(request);
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

        return Hosp_Utils.getAccessToken(username, password, ClientId, ClientSecret);
    }


    private class Hosp_HospitalWrapper {
        public String hospitalId { get; set; }
        public String externalId { get; set; }
        public String name { get; set; }
        public String country { get; set; }
        public String city { get; set; }
        public String postalCode { get; set; }
        public String street { get; set; }

        public Hosp_HospitalWrapper(Hospital__c hospital) {
            hospitalId = hospital.Id;
            externalId = hospital.ExternalId__c;
            name = hospital.Name;
            country = hospital.Country__c;
            city = hospital.City__c;
            postalCode = hospital.PostalCode__c;
            street = hospital.Street__c;
        }
    }
}