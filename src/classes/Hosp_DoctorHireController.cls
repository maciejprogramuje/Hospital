public with sharing class Hosp_DoctorHireController {
    public Hospital__c hospital { get; set; }
    public List<Hospital__c> hospitals { get; set; }
    public String currentDoctorId { get; set; }
    public String selectedHospitalId { get; set; }
    public Contract__c contract { get; set; }
    public List<Wrapper> wrappers { get; set; }

    public Hosp_DoctorHireController() {
        setHospitalEmpty();
        contract = new Contract__c();
        setHospitalsEmpty();
    }

    public void searchHospitals() {
        String query = Hosp_Utils.generateHireDoctorHospitalsQuery(hospital);

        if(String.isNotBlank(query)) {
            hospitals = Database.query(query);
        } else {
            setHospitalsEmpty();
        }

        setWrappersEmpty();

        for(Hospital__c h :  hospitals) {
            wrappers.add(new Wrapper(h));
        }
    }

    public void clearSearchForm() {
        setFieldsEmpty();
    }

    public Doctor__c getDoctor() {
        return [SELECT Id, Name, FirstLastName__c FROM Doctor__c WHERE Id = :currentDoctorId];
    }

    public Hospital__c getSelectedHospital() {
        return [SELECT Id, Name FROM Hospital__c WHERE Id = :selectedHospitalId];
    }




    public PageReference hireDoctor() {
        Contract__c contractToInsert = new Contract__c(Doctor__c = currentDoctorId, Hospital__c = selectedHospitalId, StartDate__c = contract.StartDate__c, EndDate__c = contract.EndDate__c);

        try {
            insert contractToInsert;

            PageReference acctPage = new PageReference('/' + currentDoctorId);
            acctPage.setRedirect(true);
            return acctPage;
        } catch (DmlException ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));

            return null;
        }
    }




    public void cancel() {
        setFieldsEmpty();
    }

    public Class Wrapper {
        public String hospitalId { get; set; }
        public String hospitalName { get; set; }
        public String hospitalCountry { get; set; }
        public String hospitalCity { get; set; }
        public Boolean isSelected {get; set; }

        public Wrapper(Hospital__c hosp) {
            hospitalId = hosp.Id;
            hospitalCountry = hosp.Country__c;
            hospitalName = hosp.Name;
            hospitalCity = hosp.City__c;
            isSelected = false;
        }
    }

    public void changeSelect() {
        for(Wrapper w : wrappers) {
            if(w.hospitalId == selectedHospitalId) {
                w.isSelected = true;
            } else {
                w.isSelected = false;
            }
        }
    }

    private void setHospitalEmpty() {
        hospital = new Hospital__c(Name='', WWW__c='', Master_Unit__c='', Street__c='', PostalCode__c='', City__c='', Country__c='');
    }

    private void setHospitalsEmpty() {
        hospitals = new List<Hospital__c>();
    }

    private void setWrappersEmpty() {
        wrappers = new List<Wrapper>();
    }

    private void setContractEmpty() {
        contract = new Contract__c();
    }

    private void setFieldsEmpty() {
        selectedHospitalId = '';
        currentDoctorId = '';

        setWrappersEmpty();
        setHospitalEmpty();
        setHospitalsEmpty();
        setContractEmpty();
    }
}