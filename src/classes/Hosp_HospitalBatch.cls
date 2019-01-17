global class Hosp_HospitalBatch implements Database.Batchable<sObject>, Database.Stateful {
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

        for (Hosp_HospitalLogCallout__c log : logRecords) {
            String oneRespond = log.ResponseBody__c;
            hospitalFromRespond.addAll((List<Hosp_HospitalWrapperForREST>) JSON.deserialize(oneRespond, List<Hosp_HospitalWrapperForREST>.class));
        }

        for(Hosp_HospitalWrapperForRest hospital : hospitalFromRespond){
            if(hospital.status){
                hospitalWithFail.add(hospital);
                hospital.status = true;
            }
        }

        String body = '{ "hospitals"  : ' + JSON.serialize(hospitalWithFail) + ' }';


        System.debug('Hosp_HospitalBatch - body='+body);


        //Hosp_HospitalTriggerHandler.sendHosp(body);



        /*Http http = new Http();
        HttpRequest request = getRequest('PUT', '', hospitalsJson);

        HttpResponse response = http.send(request);

        Hosp_HospitalLogCallout__c logCallout = new Hosp_HospitalLogCallout__c(
                RequestBody__c = request.getBody(),
                ResponseBody__c = response.getBody(),
                External_Id__c = '',
                CreateDate__c = Datetime.now(),
                OperationType__c = 'Send hospital',
                Status__c = String.valueOf(response.getStatusCode())
        );*/

    }

    global void finish(Database.BatchableContext bc) {

        System.debug('Hosp_HospitalBatch - doszedł do finish');

        Hosp_Utils.sendEmailToSystemAdmin(errorList);
    }
}