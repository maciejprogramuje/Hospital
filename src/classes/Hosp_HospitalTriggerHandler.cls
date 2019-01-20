public with sharing class Hosp_HospitalTriggerHandler implements ITrigger {
    public static String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';

    public void beforeInsert(List<Hospital__c> hospitals) {
        Boolean isExecuted = false;
        while (!isExecuted) {
            List<Hosp_HospitalWrapperForREST> hospitalsInWrapper = new List<Hosp_HospitalWrapperForREST>();
            for (Hospital__c hosp : hospitals) {
                Hosp_HospitalWrapperForREST hospToSend = new Hosp_HospitalWrapperForREST(hosp);
                hospToSend.status = true;
                hospitalsInWrapper.add(hospToSend);
            }
            String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';
            Hosp_HospitalTriggerHandler.sendHosp(body);
            isExecuted = true;
        }
    }

    public void beforeUpdate(List<Hospital__c> hospitals) {
        Boolean isExecuted = false;
        while (!isExecuted) {
            List<Hosp_HospitalWrapperForREST> hospitalsInWrapper = new List<Hosp_HospitalWrapperForREST>();
            for (Hospital__c hosp : hospitals) {
                Hosp_HospitalWrapperForREST hospToSend = new Hosp_HospitalWrapperForREST(hosp);
                hospToSend.status = true;
                hospitalsInWrapper.add(hospToSend);
            }
            String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';
            Hosp_HospitalTriggerHandler.sendHosp(body);
            isExecuted = true;
        }
    }

    public void beforeDelete(List<Hospital__c> hospitalMap) {
        Boolean isExecuted = false;
        while (!isExecuted) {
            List<String> hospitalsIds = new List<String>();
            for (Hospital__c hosp : hospitalMap) {
                hospitalsIds.add(hosp.ExternalId__c);
            }
            Hosp_HospitalTriggerHandler.deleteHospitalData(hospitalsIds);
            isExecuted = true;
        }
    }

    public void afterInsert(List<Hospital__c> hospitals) {

    }

    public void afterUpdate(List<Hospital__c> hospitals) {

    }

    public void afterDelete(List<Hospital__c> hospitals) {

    }

    @future(Callout=true)
    public static void sendHosp(String hospitalsJson) {
        List<Hosp_HospitalLogCallout__c> logsToInsert = new List<Hosp_HospitalLogCallout__c>();

        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', hospitalsJson);
        HttpResponse response = http.send(request);

        List<Hosp_HospitalWrapperForREST> hospitalAfterSend = ((List<Hosp_HospitalWrapperForREST>) JSON.deserialize(response.getBody(), List<Hosp_HospitalWrapperForREST>.class));

//        for (Hospital_HospitalWrapperForREST hospital : hospitalAfterSend) {
//            logsToInsert.add(new LogsWebService__c(External_Id__c = hospital.externalId, DateTime__c = Datetime.now(),
//                    OperationType__c = 'Send hospital', ParentHospital_Id__c = hospital.hospitalId, Status__c = hospital.status));
//        }
        System.debug('logsToInsert' + logsToInsert);
        insert logsToInsert;

        Hosp_HospitalLogCallout__c logsFromWebService = new Hosp_HospitalLogCallout__c(
                CreateDate__c = Datetime.now(),
                OperationType__c = 'Send hospital',
                Status__c = String.valueOf(response.getStatusCode()),
                RequestBody__c = request.getBody(),
                ResponseBody__c = response.getBody());
        System.debug('logsFromWebService' + logsFromWebService);
        insert logsFromWebService;
    }

    @future(Callout=true)
    public static void deleteHospitalData(List<String> hospitalsIds) {
        String hospitalToDeleteId;
        for (String hospId : hospitalsIds) {
            hospitalToDeleteId = hospId;
            break;
        }
        Http http = new Http();
        HttpRequest request = getRequest('DELETE', hospitalToDeleteId, '');
        HttpResponse response = http.send(request);

        List<Hosp_HospitalWrapperForREST> hospitalAfterSend = ((List<Hosp_HospitalWrapperForREST>) JSON.deserialize(response.getBody(), List<Hosp_HospitalWrapperForREST>.class));
        List<Hosp_HospitalLogCallout__c> logsToInsert = new List<Hosp_HospitalLogCallout__c>();

//        for (Hospital_HospitalWrapperForREST hospital : hospitalAfterSend) {
//            logsToInsert.add(new LogsWebService__c(External_Id__c = hospital.externalId, DateTime__c = Datetime.now(),
//                    OperationType__c = 'Delete hospital', ParentHospital_Id__c = hospital.hospitalId, Status__c = hospital.status));
//        }
//        insert logsToInsert;


        Hosp_HospitalLogCallout__c logsFromWebService = new Hosp_HospitalLogCallout__c(
                CreateDate__c = Datetime.now(),
                OperationType__c = 'Delete hospital',
                Status__c = String.valueOf(response.getStatusCode()),
                RequestBody__c = request.getBody(),
                ResponseBody__c = response.getBody());
        insert logsFromWebService;
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
}