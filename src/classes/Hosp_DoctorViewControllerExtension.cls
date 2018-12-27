public with sharing class Hosp_DoctorViewControllerExtension {
    public String renderingService { get; private set; }
    public Boolean printToPDF { get; set; }
    public String pageReferenceUrl;
    public Boolean hasAvatar { get; set; }
    public Attachment avatarSrc { get; set; }

    public Doctor__c doctorCurrent { get; set; }
    public String hireFullName { get{
        return String.format(Label.Hosp_Hire_Name, new List<String>{doctorCurrent.FirstLastName__c});
    } set; }

    public Hospital__c hospital { get; set; }
    public List<Hospital__c> hospitals { get; set; }
    public List<HospitalWrapper> hospitalsWrappers { get; set; }

    public Contract__c contract { get; set; }
    public List<Contract__c> contracts { get; set; }
    public String contractIdToDismiss { get; set; }
    public Boolean isImportSuccess { get; set; }


    public Hosp_DoctorViewControllerExtension(ApexPages.StandardController standardController) {
        doctorCurrent = (Doctor__c) standardController.getRecord();

        getContracts();
        hasAvatar = false;

        List<Attachment> savedPicture = [SELECT Id,
                Name,
                Body
            FROM Attachment
            WHERE ParentId = :doctorCurrent.Id
            AND Name = :Label.Hosp_DefaultPicture];

        if (!savedPicture.isEmpty()) {
            hasAvatar = true;
            avatarSrc = savedPicture[0];
        }

        createNewHospital();
        createNewContract();
        hospitals = new List<Hospital__c>();
        hospitalsWrappers = new List<HospitalWrapper>();
    }

    public void dismiss() {
        Contract__c contract = [SELECT Id,
                StartDate__c,
                EndDate__c,
                isFinished__c
            FROM Contract__c
            WHERE Id = :contractIdToDismiss];

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
        List<Attachment> savedPicture = [SELECT Id,
                Name,
                Body
            FROM Attachment
            WHERE ParentId = :doctorCurrent.Id
            AND name = :Label.Hosp_DefaultPicture];
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
        avatarSrc = [SELECT Id,
                Name
            FROM Attachment
            WHERE ParentId = :doctorCurrent.Id];
    }

    //
    public void searchHospitals() {
        String query = Hosp_Utils.generateHireDoctorHospitalsQuery(hospital);

        if(String.isNotBlank(query)) {
            hospitals = Database.query(query);
        } else {
            hospitals.clear();
        }

        hospitalsWrappers.clear();

        for(Hospital__c h :  hospitals) {
            hospitalsWrappers.add(new HospitalWrapper(h));
        }
    }

    public void clearSearchForm() {
        ApexPages.getMessages().clear();

        setFieldsEmpty();
    }

    public Hospital__c getSelectedHospital() {
        return [SELECT Id, Name FROM Hospital__c WHERE Id = :hospital.Id];
    }

    public void hireDoctor() {
        Contract__c contractToInsert = new Contract__c(Doctor__c = doctorCurrent.Id,
                Hospital__c = hospital.Id,
                StartDate__c = contract.StartDate__c,
                EndDate__c = contract.EndDate__c);

        try {
            insert contractToInsert;

            getContracts();

            setFieldsEmpty();
        } catch (DmlException ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));
        }
    }

    public void changeSelect() {
        for(HospitalWrapper w : hospitalsWrappers) {
            if(w.hospitalId == hospital.Id) {
                w.isSelected = true;
            } else {
                w.isSelected = false;
            }
        }
    }

    public void setFieldsEmpty() {
        hospitalsWrappers.clear();
        createNewHospital();
        hospitals.clear();
        createNewContract();
    }

    private void createNewHospital() {
        hospital = new Hospital__c();
    }

    private void createNewContract() {
        contract = new Contract__c();
    }

    public Class HospitalWrapper {
        public String hospitalId { get; set; }
        public String hospitalName { get; set; }
        public String hospitalCountry { get; set; }
        public String hospitalCity { get; set; }
        public Boolean isSelected {get; set; }

        public HospitalWrapper(Hospital__c hosp) {
            hospitalId = hosp.Id;
            hospitalCountry = hosp.Country__c;
            hospitalName = hosp.Name;
            hospitalCity = hosp.City__c;
            isSelected = false;
        }
    }
}