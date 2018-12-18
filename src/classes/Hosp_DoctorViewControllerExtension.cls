public with sharing class Hosp_DoctorViewControllerExtension {
    public List<Contract__c> contracts { get; set; }
    public String contractIdCurrent { get; set; }
    public String doctorIdCurrent { get; set; }
    public String firstLastName { get {
        Doctor__c doctor = [SELECT Id, FirstLastName__c FROM Doctor__c WHERE Id = :doctorIdCurrent];
        return doctor.FirstLastName__c;
    } set; }
    public String renderingService { get; private set; }

    public String recordId;
    public String pageReferenceUrl;
    public Boolean hasAvatar { get; set; }
    public Attachment avatarSrc { get; set; }

    public Hosp_DoctorViewControllerExtension(ApexPages.StandardController standardController) {
        doctorIdCurrent = standardController.getRecord().Id;
        getContracts();
        hasAvatar = false;

        List<Attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :doctorIdCurrent AND name = :Label.Hosp_DefaultPicture];
        if (savedPicture.size() > 0) {
            hasAvatar = true;
            avatarSrc = savedPicture[0];
        }
    }

    public void dismiss() {
        Contract__c contract = [SELECT Id, StartDate__c, EndDate__c FROM Contract__c WHERE Id = :contractIdCurrent];
        if (contract.StartDate__c > Date.today()) {
            delete contract;
        } else if (contract.StartDate__c < Date.today() && contract.EndDate__c > Date.today()) {
            contract.EndDate__c = Date.today();
            update contract;
        }

        getContracts();
    }

    public void getContracts() {
        contracts = [SELECT Id, Name, StartDate__c, EndDate__c, Doctor__r.Name, Doctor__r.FirstName__c, Doctor__r.FirstLastName__c, Doctor__r.Id, Hospital__r.Name FROM Contract__c WHERE Doctor__c = :doctorIdCurrent];
    }

    public PageReference expToPdf() {
        renderingService = 'PDF';
        PageReference pageReference = Page.Hosp_DoctorViewPdfExport;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public PageReference changeRecordPicture() {
        PageReference cropImagePage = Page.Hosp_DoctorProfileImage;
        cropImagePage.getParameters().put('recordId', doctorIdCurrent);
        cropImagePage.getParameters().put('pageReferenceURL', ApexPages.currentPage().getUrl());
        cropImagePage.setRedirect(true);

        return cropImagePage;
    }

    public void changeRecordPictureToDefault() {
        List<Attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :doctorIdCurrent AND name = :Label.Hosp_DefaultPicture];
        if (savedPicture.size() > 0) {
            delete savedPicture;
        }

        hasAvatar = false;
    }

    private PageReference prepareRecordPageReference() {
        PageReference recordPageReference = new PageReference(pageReferenceUrl);
        recordPageReference.getParameters().put('id', recordId);
        recordPageReference.setRedirect(false);

        return recordPageReference;
    }

    public void getAvatarSrc() {
        avatarSrc = [SELECT Id, Name FROM Attachment WHERE ParentId = :recordId];
    }
}