trigger Hosp_Hospital on Hospital__c (before insert, before update, before delete) {

    if (Trigger.isInsert || Trigger.isUpdate) {
        Boolean isExecuted = false;
        while (!isExecuted) {
            List<Hosp_HospitalWrapperForRest> hospitalsInWrapper = new List<Hosp_HospitalWrapperForRest>();
            for(Hospital__c hosp : Trigger.new) {
                Hosp_HospitalWrapperForREST hospToSend = new Hosp_HospitalWrapperForREST(hosp);
                hospToSend.status = true;
                hospitalsInWrapper.add(new Hosp_HospitalWrapperForRest(hosp));
            }

            String body = '{ "hospitals"  : ' + JSON.serialize(hospitalsInWrapper) + ' }';

            Hosp_HospitalTriggerHandler.sendHosp(body);
            isExecuted = true;
        }
    } else if (Trigger.isDelete) {
        Boolean isExecuted = false;
        while (!isExecuted) {
            List<String> hospitalsIds = new List<String>();
            for(Hospital__c hosp : Trigger.oldMap.values()){
                hospitalsIds.add(hosp.ExternalId__c);
            }
            Hosp_HospitalTriggerHandler.deleteHosp(hospitalsIds);
            isExecuted = true;
        }
    }

    //0051t000001bOdRAAU
}