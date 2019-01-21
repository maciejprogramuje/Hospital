trigger Hosp_Hospital on Hospital__c (before insert, before update, before delete, after insert, after update, after delete ) {
    if(Hosp_Utils.isTriggerEnabled('Hosp_Hospital__c')){
        Hosp_TriggerFactory.createHandler(Hospital__c.getSObjectType());
    }
}