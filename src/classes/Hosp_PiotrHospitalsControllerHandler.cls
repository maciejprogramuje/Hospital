public with sharing class Hosp_PiotrHospitalsControllerHandler {
    public String endPoint = Label.Hosp_Endpoint_Piotr_Hospital;

    public Hosp_PiotrHospitalsControllerHandler() {

    }

    public List<Hosp_HospitalWrapperForRest> getHospitalCallout(String queryName, String queryCity, String queryCountry) {
        String query = generateQueryForgetHospitalCallout(queryName, queryCity, queryCountry);

        Http http = new Http();
        HttpRequest request = getRequest('GET', query, '');
        HttpResponse response = http.send(request);
        List<Hosp_HospitalWrapperForRest> hospitalList = (List<Hosp_HospitalWrapperForRest>) JSON.deserialize(response.getBody(), List<Hosp_HospitalWrapperForRest>.class);

        return hospitalList;
    }

    private String generateQueryForgetHospitalCallout(String queryName, String queryCity, String queryCountry) {
        String query = '?';
        if (String.isNotBlank(queryName)) {
            query += 'Name=' + queryName + '&';
        }
        if (String.isNotBlank(queryCity)) {
            query += 'City__c=' + queryCity + '&';
        }
        if (String.isNotBlank(queryCountry)) {
            query += 'Country__c=' + queryCountry;
        }
        query = query.replaceAll(' ', '%20');

        return query;
    }

    public HttpRequest getRequest(String methodType, String urlParams, String body) {
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint + urlParams);

        //todo - warunek, by działał multimock
        if(!Test.isRunningTest()) {
            request.setHeader('Authorization', 'Bearer ' + loginToPiotrGetSessionId());
        }

        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod(methodType);
        if (body != '') {
            request.setBody(body);
        }
        return request;
    }

    public String loginToPiotrGetSessionId() {
        String username = 'maciej.szymczyk@britenet.com.pl';
        String password = 'Ulka!2002sjScbwznYDOocJSdloEwSJ8l';
        String ClientId = '3MVG9fTLmJ60pJ5KOWKrx4ZK68vbm6BizsZwIiPAZvzLsVGKYalESe4NBKdrBIrRAR0IIQ3fAaJPqJ5D5srmc';
        String ClientSecret = '8058418408902575444';

        //todo - access token

        String sessionIdToPiotr = Hosp_Utils.getAccessToken(username, password, ClientId, ClientSecret);

        return sessionIdToPiotr;
    }

    public List<Hosp_HospitalWrapperForRest> deleteHospitalCallout(String hospitalToDeleteId) {
        Http http = new Http();
        HttpRequest request = getRequest('DELETE', hospitalToDeleteId, '');
        HttpResponse response = http.send(request);
        List<Hosp_HospitalWrapperForRest> hospitalList = (List<Hosp_HospitalWrapperForRest>) JSON.deserialize(response.getBody(), List<Hosp_HospitalWrapperForRest>.class);

        return hospitalList;
    }

    public List<Hosp_HospitalWrapperForRest> upsertHospitalCallout(Hospital__c hospital) {
        String body = JSON.serialize(new Hosp_HospitalWrapperForRest(hospital), true);
        body = '{ "hospitals"  : [ ' + body + ' ] }';

        System.debug('upsertHospitalCallout body=' + body);

        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', body);

        HttpResponse response = http.send(request);
        List<Hosp_HospitalWrapperForRest> hospitalList = (List<Hosp_HospitalWrapperForRest>) JSON.deserialize(response.getBody(), List<Hosp_HospitalWrapperForRest>.class);

        System.debug('upsertHospitalCallout response.getStatus()='+response.getStatus());

        return hospitalList;
    }

}