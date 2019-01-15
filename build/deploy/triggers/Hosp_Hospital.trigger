trigger Hosp_Hospital on Hospital__c (after insert, after update, after delete) {

    if (Trigger.isInsert || Trigger.isUpdate) {
        Boolean isExecuted = false;
        while (!isExecuted) {
            Hosp_HospitalTriggerHandler.sendHosp(Trigger.newMap.keySet());
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
}