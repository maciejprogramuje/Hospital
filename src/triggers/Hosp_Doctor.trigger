trigger Hosp_Doctor on Doctor__c (after insert) {
    if(Trigger.isInsert) {
        Hosp_Utils.sendEmailToDoctor(Trigger.new);
    }
}