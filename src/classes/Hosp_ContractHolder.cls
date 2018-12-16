public with sharing class Hosp_ContractHolder {
    public static void checkConflicts(List<Contract__c> contractsToCheck) {
        for (Contract__c contractToCheck : contractsToCheck) {
            List<Contract__c> contracts = [
                    SELECT Id, Doctor__c, Hospital__c, StartDate__c, EndDate__c
                    FROM Contract__c
                    WHERE Doctor__c = :contractToCheck.Doctor__c
                    AND Hospital__c = :contractToCheck.Hospital__c
            ];

            for (Contract__c contract : contracts) {
                if ((contractToCheck.StartDate__c >= contract.StartDate__c && contractToCheck.StartDate__c <= contract.EndDate__c)
                        || (contractToCheck.EndDate__c >= contract.StartDate__c && contractToCheck.EndDate__c <= contract.EndDate__c)) {
                    String message = ' ' + contract.StartDate__c.format() + ' - ' + contract.EndDate__c.format() + '.';
                    contractToCheck.addError(Label.Contract_at_the_same_time + message, false);
                }
            }
        }
    }
}