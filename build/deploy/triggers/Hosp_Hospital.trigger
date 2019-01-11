/**
 * Created by BRITENET on 10.01.2019.
 */

trigger Hosp_Hospital on Hospital__c (after insert, after update, after delete) {
    Boolean isExecuted = false;

    while (!isExecuted) {
        if (Trigger.isInsert) {

            System.debug('Trigger.newMap.keySet()='+Trigger.newMap.keySet());

            Hosp_HospitalTriggerHandler.sendHosp(Trigger.newMap.keySet());
        }





        isExecuted = true;
    }


}