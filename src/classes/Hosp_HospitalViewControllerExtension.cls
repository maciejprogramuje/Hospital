public with sharing class Hosp_HospitalViewControllerExtension {
    public List<Contract__c> contracts { get; set; }
    public Hospital__c hospitalCurrent { get; set; }
    public String contractIdCurrent { get; set; }

    public Doctor__c doctorFromSearchForm { get; set; }
    public List<DoctorsFoundWrapper> doctorsFoundWrapper { get; set; }
    public String selectedDoctorIdInResults { get; set; }
    public String editingDoctorId { get; set; }
    public Boolean isEditingDatesFields { get; set; }
    public List<ContractsWrapper> contractsToImport { get; set; }

    public Hosp_HospitalViewControllerExtension(ApexPages.StandardController standardController) {
        hospitalCurrent = (Hospital__c) standardController.getRecord();
        getContracts();

        resetHireModalWindow();
    }

    private void resetHireModalWindow() {
        doctorFromSearchForm = new Doctor__c(Name = '');
        doctorsFoundWrapper = new List<DoctorsFoundWrapper>();
        contractsToImport = new List<ContractsWrapper>();

        isEditingDatesFields = false;
    }

    public void getContracts() {
        contracts = [
                SELECT Id,
                        Name,
                        StartDate__c,
                        EndDate__c,
                        Doctor__r.Name,
                        Doctor__r.FirstName__c,
                        Doctor__r.FirstLastName__c,
                        Doctor__r.Id,
                        Hospital__r.Name
                FROM Contract__c
                WHERE Hospital__c = :hospitalCurrent.Id
                ORDER BY StartDate__c
        ];
    }

    public void dismiss() {
        Contract__c contract = [SELECT Id, StartDate__c, EndDate__c FROM Contract__c WHERE Id = :contractIdCurrent];

        if (contract.StartDate__c > Date.today()) {
            delete contract;
        } else if (contract.StartDate__c <= Date.today() && contract.EndDate__c >= Date.today()) {
            contract.EndDate__c = Date.today();
            contract.isFinished__c = true;
            update contract;
        }

        getContracts();
    }


    public void searchDoctors() {
        doctorsFoundWrapper.clear();
        contractsToImport.clear();

        //todo - generateQuerySearchForDoctorsInHospitalViewModal
        String query = 'SELECT Id, Name, FirstName__c, FirstLastName__c, Country__c, City__c, Email__c FROM Doctor__c WHERE Name LIKE \'' + doctorFromSearchForm.Name + '%\'';

        List<Doctor__c> doctorsFound = Database.query(query);

        doctorsFoundWrapper.clear();

        for (Doctor__c d : doctorsFound) {
            doctorsFoundWrapper.add(new DoctorsFoundWrapper(d));
        }
    }

    public void clearSearchForm() {
        ApexPages.getMessages().clear();

        resetHireModalWindow();
    }

    public void changeSelectionInDoctorsFoundWrapper() {
        for (DoctorsFoundWrapper d : doctorsFoundWrapper) {
            if (selectedDoctorIdInResults == d.idFoundWrapper) {
                if (d.isSelectedFoundWrapper == true) {
                    d.isSelectedFoundWrapper = false;
                } else {
                    d.isSelectedFoundWrapper = true;

                    Contract__c c = new Contract__c(Hospital__c = hospitalCurrent.Id, Doctor__c = selectedDoctorIdInResults);
                    contractsToImport.add(new ContractsWrapper(c));
                }
                break;
            }
        }
    }

    public void editSelectedDoctor() {
        for (Integer i = 0; i < contractsToImport.size(); i++) {
            if (editingDoctorId == contractsToImport.get(i).contractInWrapper.Doctor__c) {
                contractsToImport.get(i).isEditingContractsWrapper = true;
            } else {
                contractsToImport.get(i).isEditingContractsWrapper = false;
            }
        }
    }

    public void templateSelectedDoctor() {
        Date startDate;
        Date endDate;

        for (Integer i = 0; i < contractsToImport.size(); i++) {
            if (editingDoctorId == contractsToImport.get(i).contractInWrapper.Doctor__c) {
                startDate = contractsToImport.get(i).contractInWrapper.StartDate__c;
                endDate = contractsToImport.get(i).contractInWrapper.EndDate__c;

                break;
            }
        }

        if (startDate != null && endDate != null) {
            for (Integer i = 0; i < contractsToImport.size(); i++) {
                contractsToImport.get(i).contractInWrapper.StartDate__c = startDate;
                contractsToImport.get(i).contractInWrapper.EndDate__c = endDate;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'No template data: no start date or no end date.'));
        }
    }

    public void clearSelectedDoctor() {
        for (Integer i = 0; i < contractsToImport.size(); i++) {
            if (editingDoctorId == contractsToImport.get(i).contractInWrapper.Doctor__c) {
                contractsToImport.get(i).contractInWrapper.StartDate__c = null;
                contractsToImport.get(i).contractInWrapper.EndDate__c = null;

                break;
            }
        }
    }

    public void removeSelectedDoctor() {
        for (Integer i = 0; i < contractsToImport.size(); i++) {
            if (editingDoctorId == contractsToImport.get(i).contractInWrapper.Doctor__c) {
                contractsToImport.remove(i);
                break;
            }
        }
        for (DoctorsFoundWrapper d : doctorsFoundWrapper) {
            if (d.idFoundWrapper == editingDoctorId) {
                d.isSelectedFoundWrapper = false;
                break;
            }
        }
    }

    public void saveSelectedDoctor() {
        for (Integer i = 0; i < contractsToImport.size(); i++) {
            if (editingDoctorId == contractsToImport.get(i).contractInWrapper.Doctor__c) {
                contractsToImport.get(i).contractInWrapper.StartDate__c = contractsToImport.get(i).tempContract.StartDate__c;
                contractsToImport.get(i).contractInWrapper.EndDate__c = contractsToImport.get(i).tempContract.EndDate__c;

                contractsToImport.get(i).isEditingContractsWrapper = false;
                break;
            }
        }
    }

    public void hireSelectedDoctors() {
        List<Contract__c> rawContractsToImport = new List<Contract__c>();

        for(ContractsWrapper con : contractsToImport) {
            Contract__c c = new Contract__c(
                    Doctor__c = con.contractInWrapper.Doctor__c,
                    Hospital__c = con.contractInWrapper.Hospital__c,
                    StartDate__c = con.contractInWrapper.StartDate__c,
                    EndDate__c = con.contractInWrapper.EndDate__c,
                    isFinished__c = false);

            rawContractsToImport.add(c);
        }

        List<Database.SaveResult> saveResults = Database.insert(rawContractsToImport, false);

        for(Integer i = 0; i <  saveResults.size(); i++) {
            if(saveResults.get(i).isSuccess()) {
                contractsToImport.get(i).statusContractsWrapper = Url.getSalesforceBaseUrl().toExternalForm() + '/' + saveResults.get(i).Id;
            } else {
                contractsToImport.get(i).statusContractsWrapper = saveResults.get(i).errors[0].getMessage();
            }
        }
    }


    private class DoctorsFoundWrapper {
        public String idFoundWrapper { get; set; }
        public String nameFoundWrapper { get; set; }
        public String firstNameFoundWrapper { get; set; }
        public String firstLastNameFoundWrapper { get; set; }
        public String countryFoundWrapper { get; set; }
        public String cityFoundWrapper { get; set; }
        public String emailFoundWrapper { get; set; }
        public Boolean isSelectedFoundWrapper { get; set; }


        public doctorsFoundWrapper(Doctor__c d) {
            idFoundWrapper = d.Id;
            nameFoundWrapper = d.Name;
            firstNameFoundWrapper = d.FirstName__c;
            firstLastNameFoundWrapper = d.FirstLastName__c;
            countryFoundWrapper = d.Country__c;
            cityFoundWrapper = d.City__c;
            emailFoundWrapper = d.Email__c;
            isSelectedFoundWrapper = false;
        }
    }

    private class ContractsWrapper {
        public Contract__c contractInWrapper { get; set; }
        public Contract__c tempContract { get; set; }
        public Doctor__c doctorInWrapper {
            get {
                return [SELECT Id, FirstLastName__c, Country__c FROM Doctor__c WHERE Id = :contractInWrapper.Doctor__c];
            }
            set;
        }

        public String fullNameContractsWrapper { get; set; }

        public Boolean isEditingContractsWrapper { get; set; }
        public String statusContractsWrapper { get; set; }

        public ContractsWrapper(Contract__c c) {
            contractInWrapper = c;
            tempContract = new Contract__c();

            isEditingContractsWrapper = false;
            statusContractsWrapper = '';
        }
    }
}