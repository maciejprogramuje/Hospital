public with sharing class Hosp_DoctorImportController {
    public final Integer SUCCESS { get{
        return 1;
    }}
    public final Integer ALREADY_EXISTS { get{
        return -1;
    }}
    public final Integer EMPTY_NAME { get{
        return -2;
    }}

    public Transient Blob csvFileBody { get; set; }
    public Integer fileSize { get; set; }
    public Boolean doneUploading { get; set; }
    public Transient String fileName { get; set; }
    public Transient String contentType { get; set; }
    public String csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public String[] inputValues { get; set; }
    public List<String> fieldList { get; set; }

    public Doctor__c doctor { get; set; }
    public String currentDoctorId { get; set; }
    public List<Doctor__c> doctors { get; set; }
    public List<Doctor__c> doctorsToImport { get; set; }
    public List<Hosp_WrapperDoctorsCsvImport> doctorWrappers { get; set; }
    public List<Hosp_WrapperDoctorsCsvImport> doctorsAfterImportNotSelected { get; set; }
    public List<Hosp_WrapperDoctorsCsvImport> doctorsAfterImportFailed { get; set; }
    public List<Hosp_WrapperDoctorsCsvImport> doctorsAfterImportSuccess { get; set; }

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
                Doctor__c doc = new Doctor__c(Name = '') ;
                String[] csvRecordData = csvfilelines[i].split(',');

                doc.FirstName__c = csvRecordData[0] ;
                doc.Name = csvRecordData[1];
                doc.City__c = csvRecordData[2];
                doc.Country__c = csvRecordData[3];

                doctors.add(doc);
                doctorWrappers.add(new Hosp_WrapperDoctorsCsvImport(doc));
                doneUploading = true;
            }

        } catch (Exception e) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.severity.ERROR, String.format(Label.Error_reading_CSV, new List<String>{
                    e.getMessage()
            }));
            ApexPages.addMessage(message);
        }
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

    public void revertCheckBoxes() {
        for (Hosp_WrapperDoctorsCsvImport doctorWrapper : doctorWrappers) {
            if (doctorWrapper.doctorIsSelectedWrapper) {
                doctorWrapper.doctorIsSelectedWrapper = false;
            } else {
                doctorWrapper.doctorIsSelectedWrapper = true;
            }
        }
    }

    public void clearAllCheckBoxes() {
        for (Hosp_WrapperDoctorsCsvImport doctorWrapper : doctorWrappers) {
            doctorWrapper.doctorIsSelectedWrapper = false;
        }
    }
    public void selectAllCheckBoxes() {
        for (Hosp_WrapperDoctorsCsvImport doctorWrapper : doctorWrappers) {
            doctorWrapper.doctorIsSelectedWrapper = true;
        }
    }

    public void importDoctors() {
        doctorsAfterImportSuccess = new List<Hosp_WrapperDoctorsCsvImport>();
        doctorsAfterImportFailed = new List<Hosp_WrapperDoctorsCsvImport>();

        resetDoctorWrapersStatus();

        populateDoctorsToImport();

        for (Doctor__c doc : doctorsToImport) {
            if (String.isNotBlank(doc.Name)) {
                try {
                    insert doc;
                    doctorsAfterImportSuccess.add(doctorWrapperSelectedBeforeImport(doc));
                } catch (DmlException ex) {
                    doctorsAfterImportFailed.add(doctorWrapperSelectedBeforeImport(doc));
                }
            } else {
                doctorsAfterImportFailed.add(doctorWrapperSelectedBeforeImport(doc));
            }
        }

        List<Hosp_WrapperDoctorsCsvImport> tempDoctorWrappers = (changeDoctorInformation(doctorsAfterImportSuccess, SUCCESS));
        tempDoctorWrappers.addAll(changeDoctorInformation(doctorsAfterImportFailed, ALREADY_EXISTS));
        tempDoctorWrappers.addAll(doctorsAfterImportNotSelected);

        doctorWrappers.clear();
        doctorWrappers.addAll(tempDoctorWrappers);
    }

    private Hosp_WrapperDoctorsCsvImport doctorWrapperSelectedBeforeImport(Doctor__c doc) {
        Hosp_WrapperDoctorsCsvImport doctorWrapper = new Hosp_WrapperDoctorsCsvImport(doc);
        doctorWrapper.setDoctorIsSelectedBeforeImport();
        return doctorWrapper;
    }

    private void populateDoctorsToImport() {
        doctorsToImport = new List<Doctor__c>();
        doctorsAfterImportNotSelected = new List<Hosp_WrapperDoctorsCsvImport>();

        for (Hosp_WrapperDoctorsCsvImport doc : doctorWrappers) {
            if (doc.doctorIsSelectedWrapper) {
                Doctor__c doctorToImport = new Doctor__c(
                        Name = doc.doctorNameWrapper,
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

    public List<Hosp_WrapperDoctorsCsvImport> changeDoctorInformation(List<Hosp_WrapperDoctorsCsvImport> doctorsToChange, Integer result) {
        List<Hosp_WrapperDoctorsCsvImport> doctorWrappersToReturn = new List<Hosp_WrapperDoctorsCsvImport>();

        for (Hosp_WrapperDoctorsCsvImport doctorWrapper : doctorsToChange) {
            if (String.isBlank(doctorWrapper.doctorNameWrapper)) {
                doctorWrapper.doctorInformationAfterImport = EMPTY_NAME;
            } else {
                doctorWrapper.doctorInformationAfterImport = result;
            }

            doctorWrapper.doctorIsSelectedWrapper = true;
            doctorWrapper.doctorIsSelectedBeforeImport = true;

            doctorWrappersToReturn.add(doctorWrapper);
        }

        return doctorWrappersToReturn;
    }

    private void setWrappersEmpty() {
        doctorWrappers = new List<Hosp_WrapperDoctorsCsvImport>();
    }

    private void resetDoctorWrapersStatus() {
        for (Hosp_WrapperDoctorsCsvImport doctorWrapper : doctorWrappers) {
            doctorWrapper.doctorInformationAfterImport = 0;
        }
    }

    public void clear() {
        doctorWrappers = new List<Hosp_WrapperDoctorsCsvImport>();
        doctors.clear();
        doneUploading = false;
    }
}