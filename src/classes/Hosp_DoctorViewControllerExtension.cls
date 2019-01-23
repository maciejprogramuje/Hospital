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

    public String employersPerDay { get; set; }
    public String employersPerDayLabels { get; set; }
    public String employersPerCountry { get; set; }
    public String employersPerCountryLabels { get; set; }

    public static Boolean getIsLicenseNoEnabled() {
        return Hosp_Utils.isFunctionalityEnabled('DoctorLicenseNoEnabled');
    }


    public Hosp_DoctorViewControllerExtension(ApexPages.StandardController standardController) {
        standardController.addFields(new List<String>{'FirstLastName__c'});

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

        getDoctorsPerWeek();
        getDoctorsPerCountry();
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
        if(contract.StartDate__c <= contract.EndDate__c) {
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
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.Hosp_BadDates));
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

    public void getDoctorsPerWeek() {
        List<Contract__c> contractsList = [SELECT Id, StartDate__c, EndDate__c FROM Contract__c WHERE Doctor__c = :doctorCurrent.Id];
        Map<Date, Integer> elementsToDisplay = new Map<Date, Integer>();
        List<String> stringList = new List<String>();
        Datetime dateTemp2 = Datetime.now();
        Date dateTemp = date.newinstance(dateTemp2.year(), dateTemp2.month(), dateTemp2.day());
        for (Integer i = 0; i < 6; i++) {
            elementsToDisplay.put(dateTemp.addDays(i), 0);
        }
        for (Contract__c contract : contractsList) {
            for (Date mapElement : elementsToDisplay.keySet()) {
                Date startDate = date.newinstance(contract.StartDate__c.year(), contract.StartDate__c.month(), contract.StartDate__c.day());
                Date endDate = date.newinstance(contract.EndDate__c.year(), contract.EndDate__c.month(), contract.EndDate__c.day());
                if (startDate <= mapElement && endDate >= mapElement) {
                    System.debug('counter contracts >> ' + elementsToDisplay.get(mapElement));
                    elementsToDisplay.put(mapElement, elementsToDisplay.get(mapElement) + 1);
                }
            }
        }
        employersPerDay = '';
        employersPerDayLabels = '';
        for (Date oneElement : elementsToDisplay.keySet()) {
            employersPerDay = employersPerDay + elementsToDisplay.get(oneElement) + ',';
            employersPerDayLabels = employersPerDayLabels + '\'' + oneElement.format() + '\',';
        }
        employersPerDay.substring(0, employersPerDay.length() - 1);
        employersPerDayLabels = employersPerDayLabels.substring(0, employersPerDayLabels.length() - 1);
    }

    public void getDoctorsPerCountry() {
        List<Contract__c> contractsList = [SELECT Id, Hospital__r.Country__c FROM Contract__c WHERE Doctor__c = :doctorCurrent.Id];
        Integer poland = 0;
        Integer holand = 0;
        Integer usa = 0;
        Integer australia = 0;
        for (Contract__c oneContract : contractsList) {
            if (oneContract.Hospital__r.Country__c.equalsIgnoreCase('pl')) {
                poland++;
            } else if (oneContract.Hospital__r.Country__c.equalsIgnoreCase('nl')) {
                holand++;
            } else if (oneContract.Hospital__r.Country__c.equalsIgnoreCase('usa')) {
                usa++;
            } else if (oneContract.Hospital__r.Country__c.equalsIgnoreCase('au')) {
                australia++;
            }
        }
        employersPerCountry = poland + ', ' + holand + ', ' + usa + ', ' + australia;
        employersPerCountryLabels = '\"PL\", \"NL\", \"USA\", \"AU\"';

        System.debug('employersPerCountry='+employersPerCountry);
        System.debug('employersPerCountryLabels='+employersPerCountryLabels);

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