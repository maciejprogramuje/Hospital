public with sharing class Hosp_DoctorImportController {
    public Transient Blob csvFileBody { get; set; }
    public Integer fileSize { get; set; }
    public Boolean doneUploading{ get; set; }
    public Transient String fileName { get; set; }
    public Transient String contentType { get; set; }
    public String csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public String[] inputValues { get; set; }
    public List<String> fieldList { get; set; }
    public List<Doctor__c> doctors { get; set; }
    public String doctorsToSelected { get; set; }
    public Doctor__c doctor { get; set; }
    public Boolean isSuccessDoctorImportToDataBase { get; set; }
    public List<DoctorWrapper> doctorWrappers { get; set; }
    public List<Doctor__c> doctorsBeforeImport { get; set; }
    public List<Doctor__c> doctorsToImport { get; set; }
    public List<DoctorWrapper> doctorsAfterImportNotSelected { get; set; }
    public List<DoctorWrapper> doctorsAfterImportFailed { get; set; }
    public List<DoctorWrapper> doctorsAfterImportSuccess { get; set; }
    public List<Doctor__c> doctorsFromDataBase { get; set; }
    public final Integer SUCCESS = 1;
    public final Integer FAILED = -1;
    public String currentDoctorId { get; set; }


    public Hosp_DoctorImportController() {
        csvFileLines = new String[]{
        };
        fieldList = New List<string>();
        doctors = New List<Doctor__c>();

        setWrappersEmpty();
    }

    public void importCSVFile() {
        if (!doctors.isEmpty()) {
            doctors.clear();
            setWrappersEmpty();
        }

        try {
            fileName = Hosp_Utils.blobToString(csvFileBody, Label.Iso_Code);
            checkCorrectImportFile();

            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            inputValues = new String[]{
            };

            for (String st : csvFileLines[0].split(',')) {
                fieldList.add(st);
            }

            for (Integer i = 1; i < csvFileLines.size(); i++) {
                Doctor__c doctor = new Doctor__c(Name = '') ;
                String[] csvRecordData = csvfilelines[i].split(',');

                doctor.FirstName__c = csvRecordData[0] ;
                doctor.Name = csvRecordData[1];
                doctor.City__c = csvRecordData[2];
                doctor.Country__c = csvRecordData[3];

                doctors.add(doctor);
                doctorWrappers.add(new DoctorWrapper(doctor));
                doneUploading = true;
            }

        } catch (Exception e) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.severity.ERROR, String.format(Label.Error_reading_CSV, new List<String>{
                    e.getMessage()
            }));
            ApexPages.addMessage(message);
        }
    }

    private void setWrappersEmpty() {
        doctorWrappers = new List<DoctorWrapper>();
    }

    public void checkCorrectImportFile() {
        try {
            if (fileName.endsWithIgnoreCase('csv')) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Upload_CSV_please);
                ApexPages.addMessage(msg);
            } else {
                doneUploading = true;
            }
        } catch (Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.Message, new List<String>{
                    ex.getStackTraceString(), ex.getMessage()
            }));
            ApexPages.addMessage(msg);
        }

    }

    public List<SelectOption> getSelectedDoctorOptions() {
        List<SelectOption> selectOptions = new List<SelectOption>();

        selectOptions.add(new SelectOption(Label.SelectAll, Label.SelectAll));
        selectOptions.add(new SelectOption(Label.Deselect, Label.Deselect));
        selectOptions.add(new SelectOption(Label.ClearAll, Label.ClearAll));

        return selectOptions;
    }

    public void serviceOnCheckBox() {
        System.debug(doctorsToSelected);
    }

    public void deselectCheckBox() {
        for (DoctorWrapper doct : doctorWrappers) {
            if (doct.doctorIsSelectedWrapper) {
                doct.doctorIsSelectedWrapper = false;
            } else {
                doct.doctorIsSelectedWrapper = true;
            }
        }
    }

    public void clearAllCheckBox() {
        for (DoctorWrapper doct : doctorWrappers) {
            doct.doctorIsSelectedWrapper = false;
        }
    }
    public void selectCheckBox() {
        for (DoctorWrapper doct : doctorWrappers) {
            doct.doctorIsSelectedWrapper = true;
        }
    }

    public void importDoctors() {
        doctorsAfterImportSuccess = new List<DoctorWrapper>();
        doctorsAfterImportFailed = new List<DoctorWrapper>();

        resetDoctorWrapersStatus();

        doctorsToImport();

        for (Doctor__c oneDoctor : doctorsToImport) {
            try {
                insert oneDoctor;
                DoctorWrapper doctorWrapper = new DoctorWrapper(oneDoctor);
                doctorWrapper.setDoctorIsSelectedBeforeImport();
                doctorsAfterImportSuccess.add(doctorWrapper);
            } catch (DmlException ex) {
                DoctorWrapper doctorWrapper = new DoctorWrapper(oneDoctor);
                doctorWrapper.setDoctorIsSelectedBeforeImport();
                doctorsAfterImportFailed.add(doctorWrapper);
            }
        }

        List<DoctorWrapper> temporaryDoctorWrappers = (changeDoctorInformation(doctorsAfterImportSuccess, SUCCESS));
        temporaryDoctorWrappers.addAll(changeDoctorInformation(doctorsAfterImportFailed, FAILED));
        temporaryDoctorWrappers.addAll(doctorsAfterImportNotSelected);

        doctorWrappers.clear();
        doctorWrappers.addAll(temporaryDoctorWrappers);
    }

    private void resetDoctorWrapersStatus() {
        for(DoctorWrapper doctorWrapper : doctorWrappers) {
            doctorWrapper.doctorInformationAfterImport = 0;
        }
    }

    public void deleteDoctors() {
        doctorsToImport();

        delete doctorsToImport;
    }

    public void clear() {
        doctorWrappers = new List<DoctorWrapper>();
        doctors.clear();
        doneUploading = false;
    }

    /*private void doctorsFromDataBase() {
        String query = 'SELECT Id, FirstName__c, Name, Email__c, Country__c, City__c, FirstLastName__c, FROM Doctor__c';

        doctorsFromDataBase = new List<Doctor__c>();

        if (String.isNotBlank(query)) {
            doctorsFromDataBase = Database.query(query);
        } else {
            doctorsFromDataBase = new List<Doctor__c>();
        }

        //doctorsFromDataBase = [SELECT Id, FirstName__c, Name, Email__c, Country__c, City__c, FirstLastName__c FROM Doctor__c];
    }*/

    private void doctorsToImport() {
        doctorsToImport = new List<Doctor__c>();
        doctorsAfterImportNotSelected = new List<DoctorWrapper>();

        for (DoctorWrapper doc : doctorWrappers) {
            if (doc.doctorIsSelectedWrapper) {
                Doctor__c doctorToImport = new Doctor__c(Name = doc.doctorNameWrapper,
                        FirstName__c = doc.doctorFirstNameWrapper,
                        City__c = doc.doctorCityWrapper,
                        Country__c = doc.doctorCountryWrapper,
                        Phone__c = '');

                doctorsToImport.add(doctorToImport);
            } else {
                doctorsAfterImportNotSelected.add(doc);
            }
        }
    }

    public List<DoctorWrapper> changeDoctorInformation(List<DoctorWrapper> doctorsToChange, Integer result) {
        List<DoctorWrapper> doctorWrappersToReturn = new List<DoctorWrapper>();

        for (DoctorWrapper doctorWrapper : doctorsToChange) {
            doctorWrapper.doctorInformationAfterImport = result;
            doctorWrapper.doctorIsSelectedWrapper = true;
            doctorWrapper.doctorIsSelectedBeforeImport = true;
            doctorWrappersToReturn.add(doctorWrapper);
        }

        return doctorWrappersToReturn;
    }

    public List<DoctorWrapper> removeDoctorsFromDoctorWrappers(List<DoctorWrapper> doctorsAfterImport) {
        List<DoctorWrapper> doctorWrapp = new List<DoctorWrapper>();

        for (DoctorWrapper doctorWrapper : doctorsAfterImport) {
            if ((doctorWrapper.doctorIsSelectedBeforeImport = false)) {
                doctorWrapp.add(doctorWrapper);
            }
        }

        return doctorWrapp;
    }


    public class DoctorWrapper {
        public String doctorIdWrapper { get; set; }
        public String doctorNameWrapper { get; set; }
        public String doctorFirstNameWrapper { get; set; }
        public String doctorCountryWrapper { get; set; }
        public String doctorCityWrapper { get; set; }
        public Boolean doctorIsSelectedWrapper { get; set; }
        public Boolean doctorIsSelectedBeforeImport { get; set; }
        public Integer doctorInformationAfterImport { get; set; }

        public DoctorWrapper(Doctor__c doc) {
            doctorIdWrapper = doc.Id;
            doctorNameWrapper = doc.Name;
            doctorFirstNameWrapper = doc.FirstName__c;
            doctorCountryWrapper = doc.Country__c;
            doctorCityWrapper = doc.City__c;
            doctorIsSelectedWrapper = true;
            doctorInformationAfterImport = 0;
            doctorIsSelectedBeforeImport = false;
        }

        public void setDoctorIsSelectedBeforeImport() {
            this.doctorIsSelectedBeforeImport = true;
        }
    }
}