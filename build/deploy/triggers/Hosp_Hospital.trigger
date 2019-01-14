/**
 * Created by BRITENET on 10.01.2019.
 */

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
            Hosp_HospitalTriggerHandler.deleteHosp(Trigger.oldMap.keySet());
            isExecuted = true;
        }
    }


}