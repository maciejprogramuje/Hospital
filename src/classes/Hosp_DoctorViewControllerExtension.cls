public with sharing class Hosp_DoctorViewControllerExtension {
    public List<Contract__c> contracts { get; set; }
    public String contractIdCurrent { get; set; }
    public Doctor__c doctorCurrent { get; set; }
    public String firstLastName { get {
        Doctor__c doctor = [SELECT Id, FirstLastName__c FROM Doctor__c WHERE Id = :doctorCurrent.Id];
        return doctor.FirstLastName__c;
    } set; }
    public String hireFullName { get{
        return String.format(Label.Hosp_Hire_Name, new List<String>{firstLastName});
    } set; }

    public String renderingService { get; private set; }
    public Boolean printToPDF { get; set; }

    public String pageReferenceUrl;
    public Boolean hasAvatar { get; set; }
    public Attachment avatarSrc { get; set; }

    public Hospital__c hospital { get; set; }
    public List<Hospital__c> hospitals { get; set; }
    public String selectedHospitalId { get; set; }
    public Contract__c contract { get; set; }
    public List<Wrapper> wrappers { get; set; }
    public Boolean isImportSuccess { get; set; }


    public Hosp_DoctorViewControllerExtension(ApexPages.StandardController standardController) {
        doctorCurrent = (Doctor__c) standardController.getRecord();
        getContracts();
        hasAvatar = false;

        List<Attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :doctorCurrent.Id AND name = :Label.Hosp_DefaultPicture];
        if (savedPicture.size() > 0) {
            hasAvatar = true;
            avatarSrc = savedPicture[0];
        }

        setHospitalEmpty();
        contract = new Contract__c();
        setHospitalsEmpty();
    }

    public void dismiss() {
        Contract__c contract = [SELECT Id, StartDate__c, EndDate__c, isFinished__c  FROM Contract__c WHERE Id = :contractIdCurrent];
        if (contract.StartDate__c > Date.today()) {
            delete contract;
        } else if (contract.StartDate__c <= Date.today() && contract.EndDate__c >= Date.today()) {
            contract.EndDate__c = Date.today();
            contract.isFinished__c = true;
            update contract;
        }

        getContracts();
    }

    public void getContracts() {
        contracts = [SELECT Id,
                Name,
                StartDate__c,
                EndDate__c,
                Doctor__r.Name,
                Doctor__r.FirstName__c,
                Doctor__r.FirstLastName__c,
                Doctor__r.Id,
                Hospital__r.Name
            FROM Contract__c
            WHERE Doctor__c = :doctorCurrent.Id
            ORDER BY StartDate__c];
    }

    public PageReference expToPdf() {
        renderingService = 'PDF';

        PageReference pageReference = Page.Hosp_DoctorViewPdfExport;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public PageReference changeRecordPicture() {
        PageReference cropImagePage = Page.Hosp_DoctorProfileImage;
        cropImagePage.getParameters().put('recordId', doctorCurrent.Id);
        cropImagePage.getParameters().put('pageReferenceURL', ApexPages.currentPage().getUrl());
        cropImagePage.setRedirect(true);

        return cropImagePage;
    }

    public void changeRecordPictureToDefault() {
        List<Attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :doctorCurrent.Id AND name = :Label.Hosp_DefaultPicture];
        if (savedPicture.size() > 0) {
            delete savedPicture;
        }

        hasAvatar = false;
    }

    private PageReference prepareRecordPageReference() {
        PageReference recordPageReference = new PageReference(pageReferenceUrl);
        recordPageReference.getParameters().put('id', doctorCurrent.Id);
        recordPageReference.setRedirect(false);

        return recordPageReference;
    }

    public void getAvatarSrc() {
        avatarSrc = [SELECT Id, Name FROM Attachment WHERE ParentId = :doctorCurrent.Id];
    }

    //
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
        ApexPages.getMessages().clear();

        setFieldsEmpty();
    }

    public Doctor__c getDoctor() {
        return [SELECT Id, Name, FirstLastName__c FROM Doctor__c WHERE Id = :doctorCurrent.Id];
    }

    public Hospital__c getSelectedHospital() {
        return [SELECT Id, Name FROM Hospital__c WHERE Id = :selectedHospitalId];
    }

    public void hireDoctor() {
        Contract__c contractToInsert = new Contract__c(Doctor__c = doctorCurrent.Id, Hospital__c = selectedHospitalId, StartDate__c = contract.StartDate__c, EndDate__c = contract.EndDate__c);

        try {
            insert contractToInsert;

            getContracts();

            setFieldsEmpty();
        } catch (DmlException ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));
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

    public void setFieldsEmpty() {
        selectedHospitalId = '';

        setWrappersEmpty();
        setHospitalEmpty();
        setHospitalsEmpty();
        setContractEmpty();
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
}