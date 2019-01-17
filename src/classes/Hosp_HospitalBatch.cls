global class Hosp_HospitalBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';
    String statusSuccess = '200';
    List<String> errorList = new List<String>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, ' +
                'External_Id__c, ' +
                'CreateDate__c, ' +
                'Status__c, ' +
                'RequestBody__c, ' +
                'ResponseBody__c ' +
                'FROM Hosp_HospitalLogCallout__c ';

        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext bc, List<Hosp_HospitalLogCallout__c> logRecords) {
        List<Hosp_HospitalWrapperForREST> hospitalFromRespond = new List<Hosp_HospitalWrapperForREST>();
        List<Hosp_HospitalWrapperForREST> hospitalWithFail = new List<Hosp_HospitalWrapperForREST>();
        List<Hosp_HospitalWrapperForRest> hospitalWithFailUnique = new List<Hosp_HospitalWrapperForRest>();

        for (Hosp_HospitalLogCallout__c log : logRecords) {
            String oneRespond = log.ResponseBody__c;
            hospitalFromRespond.addAll((List<Hosp_HospitalWrapperForREST>) JSON.deserialize(oneRespond, List<Hosp_HospitalWrapperForREST>.class));
        }

        for (Hosp_HospitalWrapperForRest hospital : hospitalFromRespond) {
            if (!hospital.status) {
                hospitalWithFail.add(hospital);
                hospital.status = true;
            }
        }

        hospitalWithFailUnique = getUniqueValues(hospitalWithFail);

        String body = '{ "hospitals"  : ' + JSON.serialize(hospitalWithFail) + ' }';

        HttpResponse response = sendHosp(body);

        List<Hosp_HospitalWrapperForRest> hospitalAfterSend = ((List<Hosp_HospitalWrapperForRest>) JSON.deserialize(response.getBody(), List<Hosp_HospitalWrapperForRest>.class));

        for (Hosp_HospitalWrapperForRest hospital : hospitalAfterSend) {
            if (!hospital.status) {
                errorList.add('Record id: ' + hospital.externalId + ' Hospital name: ' + hospital.name);
            }
        }
    }

    private List<Hosp_HospitalWrapperForRest> getUniqueValues(List<Hosp_HospitalWrapperForRest> records) {
        Map<String, Hosp_HospitalWrapperForRest> uniqueValues = new Map<String, Hosp_HospitalWrapperForRest>();

        for (Hosp_HospitalWrapperForRest record : records) {
            if (!uniqueValues.containsKey(record.externalId)) {
                uniqueValues.put(record.externalId, record);
            }
        }
        return uniqueValues.values();
    }

    public HttpResponse sendHosp(String hospitalsJson) {
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

        System.debug('logsFromWebService' + logCallout);

        insert logCallout;

        return response;
    }

    public HttpRequest getRequest(String methodType, String urlParams, String body) {
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


    global void finish(Database.BatchableContext bc) {
        Hosp_Utils.sendEmailToSystemAdmin(errorList);
    }
}