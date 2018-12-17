trigger Hosp_Contract on Contract__c (before insert, before update) {
    if (Trigger.isInsert || Trigger.isUpdate) {
        Hosp_ContractHandler.checkConflicts(Trigger.new);
    }
}