public with sharing class Hosp_HospitalTriggerHandler {
    public static String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';

    @future(Callout=true)
    public static void sendHosp(String hospitalsJson) {
        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', hospitalsJson);

        HttpResponse response = http.send(request);
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
        request.setHeader('Authorization', 'Bearer ' + loginToSecondOrgGetSessionId());
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod(methodType);
        if (body != '') {
            request.setBody(body);
        }
        return request;
    }

    public static String loginToSecondOrgGetSessionId() {
        String username = 'maciejsz1979@gmail.com.dev';
        String password = 'Ulka!2002WieDb9l7JqvBVtrYrgpJ6uOU';
        String ClientId = '3MVG9fTLmJ60pJ5IEt_O_REmXnukYYpcAtLEDZvLCLKn97kttZQ0.A.Wi._ZDE6vVrYsKPZEoJL3_RW0jU2WU';
        String ClientSecret = '6739776878073564220';

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