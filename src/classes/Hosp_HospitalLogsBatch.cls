global class Hosp_HospitalLogsBatch implements Database.Batchable<sObject> {
    public String query;

    global Database.QueryLocator start(Database.BatchableContext BC){
        Datetime dateNow = Datetime.now();
        dateNow = dateNow.addDays(-1);

        query = 'SELECT Id, DateTime__c FROM LogsFromWebService__c WHERE DateTime__c < '+dateNow.format('yyyy-MM-dd')+'T'+ dateNow.format('HH:mm')+':00.000Z';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> results){
        delete results;
    }

    global void finish(Database.BatchableContext BC){

        //todo - a co tutaj?

    }
}