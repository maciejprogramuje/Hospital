global class Hosp_HospitalBatch implements Database.Batchable<sObject>, Database.Stateful {
    String statusSuccess = '200';
    List<String> errorList = new List<String>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, ' +
                'External_Id__c, ' +
                'DateTime__c, ' +
                'Status__c OperationType__c, ' +
                'Request__c, ' +
                'Respond__c ' +
                'FROM LogsFromWebService__c ' +
                'WHERE Status__c != \'' + statusSuccess + '\'';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Hosp_HospitalLogCallout__c> logRecords) {
        List<Hosp_HospitalWrapperForREST> hospitalFromRespond = new List<Hosp_HospitalWrapperForREST>();
        List<Hosp_HospitalWrapperForREST> hospitalWithFail = new List<Hosp_HospitalWrapperForREST>();

        for (Hosp_HospitalLogCallout__c log : logRecords) {
            String oneRespond = log.ResponseBody__c;
            hospitalFromRespond.addAll((List<Hosp_HospitalWrapperForREST>) JSON.deserialize(oneRespond, List<Hosp_HospitalWrapperForREST>.class));
        }

        for(Hosp_HospitalWrapperForREST hospital : hospitalFromRespond){
            if(hospital.status){
                hospitalWithFail.add(hospital);
                hospital.status = true;
            }
        }
        String body = '{ "hospitals"  : ' + JSON.serialize(hospitalWithFail) + ' }';
        Hosp_HospitalTriggerHandler.sendHosp(body);
    }

    global void finish(Database.BatchableContext bc) {
        //Hosp_Utils.sendEmailToSystemAdmin(errorList);
    }
}