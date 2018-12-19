public with sharing class Hosp_ContractHandler {
    public static void checkConflicts(List<Contract__c> contractsToCheck) {
        List<Contract__c> contracts;

        for (Contract__c contractToCheck : contractsToCheck) {
            contracts = [
                    SELECT Id, Doctor__c, Hospital__c, StartDate__c, EndDate__c
                    FROM Contract__c
                    WHERE Doctor__c = :contractToCheck.Doctor__c
                    AND Id <> :contractToCheck.Id
                    AND Hospital__c = :contractToCheck.Hospital__c
                    AND StartDate__c >= :contractToCheck.StartDate__c
                    AND IsFinished__c = false
                    ORDER BY StartDate__c
            ];

            for (Contract__c contract : contracts) {
                if ((contractToCheck.StartDate__c >= contract.StartDate__c && contractToCheck.StartDate__c <= contract.EndDate__c)
                        || (contractToCheck.EndDate__c >= contract.StartDate__c && contractToCheck.EndDate__c <= contract.EndDate__c)
                        || (contractToCheck.StartDate__c < contract.StartDate__c && contractToCheck.EndDate__c > contract.EndDate__c)) {

                    contractToCheck.addError(String.format(Label.Contract_at_the_same_time, new List<String>{contract.StartDate__c.format(), contract.EndDate__c.format()}), false);
                }
            }
        }
    }
}