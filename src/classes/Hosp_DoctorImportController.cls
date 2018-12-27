public with sharing class Hosp_DoctorImportController {
    public List<DoctorImportWrapper> doctorsFromFile { get; set; }

    public Transient Blob csvFileBody { get; set; }
    public Boolean doneUploading { get; set; }
    public Transient String fileName { get; set; }
    public Transient String contentType { get; set; }
    public String csvAsString { get; set; }
    public List<String> csvFileLines { get; set; }
    public List<String> inputValues { get; set; }
    public Boolean areAllCheckboxesSelected { get; set; }


    public Hosp_DoctorImportController() {
        csvFileLines = new List<String>();
        doctorsFromFile = new List<Hosp_DoctorImportController.DoctorImportWrapper>();
        areAllCheckboxesSelected = true;
    }

    public PageReference importCSVFile() {
        doctorsFromFile.clear();

        try {
            fileName = Hosp_Utils.blobToString(csvFileBody, Label.Iso_Code);
            checkCorrectImportFile();

            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            inputValues = new List<String>();

            for (Integer i = 1; i < csvFileLines.size(); i++) {
                List<String> csvRecordData = csvFileLines[i].split(',');

                Doctor__c doc = new Doctor__c(Name = '') ;
                doc.FirstName__c = csvRecordData[0] ;
                doc.Name = csvRecordData[1];
                doc.City__c = csvRecordData[2];
                doc.Country__c = csvRecordData[3];

                doctorsFromFile.add(new DoctorImportWrapper(doc));

                doneUploading = true;
            }
        } catch (Exception e) {
            System.debug(e);
            ApexPages.Message message = new ApexPages.Message(ApexPages.severity.ERROR, Label.Error_reading_CSV);
            ApexPages.addMessage(message);
        }

        return null;
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
            System.debug(ex);
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.Message, new List<String>{
                    ex.getStackTraceString(), ex.getMessage()
            }));
            ApexPages.addMessage(msg);
        }

    }

    public void revertCheckBoxes() {
        for (DoctorImportWrapper doc : doctorsFromFile) {
            doc.isSelectedWrapper = !doc.isSelectedWrapper;
        }
    }

    public void changeAllCheckBoxes() {
        for (DoctorImportWrapper doc : doctorsFromFile) {
            doc.isSelectedWrapper = areAllCheckboxesSelected;
        }
    }

    public void importCheckedDoctors() {
        List<DoctorImportWrapper> doctorsToImport = new List<DoctorImportWrapper>();

        for (DoctorImportWrapper doc : doctorsFromFile) {
            if (doc.isSelectedWrapper) {
                doctorsToImport.add(doc);
            }
        }

        List<Doctor__c> rawDoctorsToImport = new List<Doctor__c>();
        for (DoctorImportWrapper doc : doctorsToImport) {
            Doctor__c d = new Doctor__c(Name = doc.doctorInWrapper.Name,
                    FirstName__c = doc.doctorInWrapper.FirstName__c,
                    Country__c = doc.doctorInWrapper.Country__c,
                    City__c = doc.doctorInWrapper.City__c);

            rawDoctorsToImport.add(d);
        }

        List<Database.SaveResult> saveResults = Database.insert(rawDoctorsToImport, false);


        for(Integer i = 0; i <  saveResults.size(); i++) {
            if(saveResults.get(i).isSuccess()) {
                doctorsToImport.get(i).statusWrapper = Label.Success;
                doctorsToImport.get(i).doctorInWrapper.Id = saveResults.get(i).Id;
            } else {
                doctorsToImport.get(i).statusWrapper = saveResults.get(i).errors[0].getMessage();
            }
        }

        for(DoctorImportWrapper docWithStatus : doctorsToImport) {
            for(DoctorImportWrapper docFromFile : doctorsFromFile) {
                if(docFromFile.guidWrapper ==  docWithStatus.guidWrapper) {
                    docFromFile.statusWrapper = docWithStatus.statusWrapper;
                    break;
                }
            }
        }
    }

    public void clear() {
        doctorsFromFile.clear();
        doneUploading = false;
    }


    private class DoctorImportWrapper {
        public Doctor__c doctorInWrapper { get; set; }
        public Boolean isSelectedWrapper { get; set; }
        public String guidWrapper;
        public String statusWrapper { get; set; }

        public DoctorImportWrapper(Doctor__c doc) {
            doctorInWrapper = doc;

            isSelectedWrapper = true;
            guidWrapper = Hosp_Utils.generateGuid();
            statusWrapper = '';
        }
    }
}