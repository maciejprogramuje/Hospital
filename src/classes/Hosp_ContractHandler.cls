public with sharing class Hosp_ContractHandler {
    public static void checkConflicts(List<Contract__c> contractsToCheck) {
        Boolean isConflict = false;
        String message = '';
        List<Contract__c> contracts;

        for (Contract__c contractToCheck : contractsToCheck) {
            contracts = [
                    SELECT Id, Doctor__c, Hospital__c, StartDate__c, EndDate__c
                    FROM Contract__c
                    WHERE Doctor__c = :contractToCheck.Doctor__c
                    AND Hospital__c = :contractToCheck.Hospital__c
                    AND StartDate__c >= :contractToCheck.StartDate__c
            ];

            for (Contract__c contract : contracts) {
                if ((contractToCheck.StartDate__c >= contract.StartDate__c && contractToCheck.StartDate__c <= contract.EndDate__c)
                        || (contractToCheck.EndDate__c >= contract.StartDate__c && contractToCheck.EndDate__c <= contract.EndDate__c)
                        || (contractToCheck.StartDate__c < contract.StartDate__c && contractToCheck.EndDate__c > contract.EndDate__c)) {

                    List<Date> conflictDates = new List<Date>{contract.StartDate__c, contract.EndDate__c};
                    conflictDates.sort();
                    List<String> conflictStrings = new List<String>();
                    for(Date d : conflictDates) {
                        conflictStrings.add(d.format());
                    }

                    String lineMessage = String.format(', from {0} to {1}', conflictStrings);

                    message += lineMessage;

                    contractToCheck.addError(String.format('{0}{1}', new List<String>{Label.Contract_at_the_same_time, message}), false);
                }
            }
        }
    }
}