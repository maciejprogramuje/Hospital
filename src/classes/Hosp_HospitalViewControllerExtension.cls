public with sharing class Hosp_HospitalViewControllerExtension {
    public static Hospital__c hospitalCurrent { get; set; }
    public Doctor__c doctorFromSearchForm { get; set; }

    public String hireDialogName { get; set; }
    public String contractIdCurrent { get; set; }
    public String selectedDoctorIdInResults { get; set; }
    public String editingDoctorId { get; set; }

    public List<Contract__c> contracts { get; set; }
    public List<DoctorsFoundWrapper> doctorsFoundWrapper { get; set; }
    public List<ContractsWrapper> contractsToImport { get; set; }

    public Boolean isAnyBadStatusInImport { get; set; }
    public Boolean isEditingDatesFields { get; set; }
    public Boolean areAllButtonDisabled { get; set; }

    public static Boolean getIsAddressEnabled() {
        if(hospitalCurrent != null) {
            return Hosp_Utils.isFunctionalityEnabled('AddressEnabled', hospitalCurrent.Country__c);
        }
        return false;
    }

    public Hosp_HospitalViewControllerExtension(ApexPages.StandardController standardController) {
        hospitalCurrent = (Hospital__c) standardController.getRecord();
        hireDialogName = String.format(Label.Hosp_Hire_Doc_to_Hosp, new List<String>{
                hospitalCurrent.Name
        });
        getContracts();

        resetHireModalWindow();
    }

    public void resetHireModalWindow() {
        contractsToImport = new List<ContractsWrapper>();
        clearSearchForm();
    }

    public void clearSearchForm() {
        ApexPages.getMessages().clear();

        doctorFromSearchForm = new Doctor__c();
        doctorsFoundWrapper = new List<DoctorsFoundWrapper>();

        isEditingDatesFields = false;
        isAnyBadStatusInImport = false;
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
        Contract__c contract = [SELECT Id,
                StartDate__c,
                EndDate__c
            FROM Contract__c
            WHERE Id = :contractIdCurrent];

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

        List<Doctor__c> doctorsFound = Database.query(Hosp_Utils.generateQuerySearchForDoctorsInHospitalViewModal(doctorFromSearchForm));

        for (Doctor__c doc : doctorsFound) {
            doctorsFoundWrapper.add(new DoctorsFoundWrapper(doc, isNotAlreadyInContractsToImport(doc.Id)));
        }
    }

    private Boolean isNotAlreadyInContractsToImport(String selDocIdResults) {
        for (ContractsWrapper contr : contractsToImport) {
            if (contr.contractInWrapper.Doctor__c == selDocIdResults) {
                return true;
            }
        }
        return false;
    }


    public void changeSelectionInDoctorsFoundWrapper() {
        for (DoctorsFoundWrapper doc : doctorsFoundWrapper) {
            if (selectedDoctorIdInResults == doc.doctorInWrapper.Id) {
                if (doc.isSelectedFoundWrapper == true) {
                    doc.isSelectedFoundWrapper = false;
                } else {
                    doc.isSelectedFoundWrapper = true;

                    Contract__c contr = new Contract__c(Hospital__c = hospitalCurrent.Id, Doctor__c = selectedDoctorIdInResults);

                    contractsToImport.add(new ContractsWrapper(contr, doc.doctorInWrapper.FirstLastName__c, doc.doctorInWrapper.Country__c));
                }
                break;
            }
        }
    }

    public void editSelectedDoctor() {
        areAllButtonDisabled = true;

        for (Integer i = 0; i < contractsToImport.size(); i++) {
            if (editingDoctorId == contractsToImport.get(i).contractInWrapper.Doctor__c) {
                if (contractsToImport.get(i).contractInWrapper.StartDate__c == null
                        && contractsToImport.get(i).contractInWrapper.EndDate__c == null) {
                    contractsToImport.get(i).tempContract = new Contract__c();
                } else {
                    contractsToImport.get(i).tempContract.StartDate__c = contractsToImport.get(i).contractInWrapper.StartDate__c;
                    contractsToImport.get(i).tempContract.EndDate__c = contractsToImport.get(i).contractInWrapper.EndDate__c;
                }

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

        for (Integer i = 0; i < contractsToImport.size(); i++) {
            if (contractsToImport.get(i).statusContractsWrapper != Label.Success) {
                contractsToImport.get(i).contractInWrapper.StartDate__c = startDate;
                contractsToImport.get(i).contractInWrapper.EndDate__c = endDate;
            }
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
            if (d.doctorInWrapper.Id == editingDoctorId) {
                d.isSelectedFoundWrapper = false;
                break;
            }
        }
    }

    public void saveSelectedDoctor() {
        for (Integer i = 0; i < contractsToImport.size(); i++) {
            if (editingDoctorId == contractsToImport.get(i).contractInWrapper.Doctor__c) {
                if (contractsToImport.get(i).tempContract.StartDate__c <= contractsToImport.get(i).tempContract.EndDate__c) {
                    areAllButtonDisabled = false;

                    contractsToImport.get(i).contractInWrapper.StartDate__c = contractsToImport.get(i).tempContract.StartDate__c;
                    contractsToImport.get(i).contractInWrapper.EndDate__c = contractsToImport.get(i).tempContract.EndDate__c;

                    contractsToImport.get(i).isEditingContractsWrapper = false;

                    break;
                } else {
                    contractsToImport.get(i).statusContractsWrapper = Label.Hosp_BadDates;
                }
            }
        }
    }

    public void hireSelectedDoctors() {
        isAnyBadStatusInImport = false;

        List<Contract__c> rawContractsToImport = new List<Contract__c>();

        for (ContractsWrapper con : contractsToImport) {
            if (con.statusContractsWrapper != Label.Success) {
                Contract__c c = new Contract__c(
                        Doctor__c = con.contractInWrapper.Doctor__c,
                        Hospital__c = con.contractInWrapper.Hospital__c,
                        StartDate__c = con.contractInWrapper.StartDate__c,
                        EndDate__c = con.contractInWrapper.EndDate__c,
                        isFinished__c = false);

                rawContractsToImport.add(c);
            }
        }

        List<Database.SaveResult> saveResults = Database.insert(rawContractsToImport, false);

        for (Integer i = 0; i < saveResults.size(); i++) {
            if (saveResults.get(i).isSuccess()) {
                contractsToImport.get(i).statusContractsWrapper = Label.Success;
            } else {
                contractsToImport.get(i).statusContractsWrapper = saveResults.get(i).errors[0].getMessage();

                isAnyBadStatusInImport = true;
            }
        }

        getContracts();
    }

    private class DoctorsFoundWrapper {
        public Doctor__c doctorInWrapper { get; set; }
        public Boolean isSelectedFoundWrapper { get; set; }

        public doctorsFoundWrapper(Doctor__c doc, Boolean isOnImportList) {
            doctorInWrapper = doc;

            isSelectedFoundWrapper = isOnImportList;
        }
    }

    private class ContractsWrapper {
        public Contract__c contractInWrapper { get; set; }
        public Contract__c tempContract { get; set; }
        public String doctorName { get; set; }
        public String doctorCountry { get; set; }
        public Boolean isEditingContractsWrapper { get; set; }
        public String statusContractsWrapper { get; set; }

        public ContractsWrapper(Contract__c contr, String doctorName, String doctorCountry) {
            contractInWrapper = contr;
            tempContract = new Contract__c();
            this.doctorName = doctorName;
            this.doctorCountry = doctorCountry;

            isEditingContractsWrapper = false;
            statusContractsWrapper = '';
        }
    }
}