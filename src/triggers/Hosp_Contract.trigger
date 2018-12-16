trigger Hosp_Contract on Contract__c (before insert, before update) {
    if (Trigger.isInsert || Trigger.isUpdate) {
        Hosp_ContractHolder.checkConflicts(Trigger.new);
    }
}