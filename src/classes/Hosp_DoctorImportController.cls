public with sharing class Hosp_DoctorImportController {
    public Blob csvFileBody { get; set; }
    public String csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public String[] inputValues { get; set; }
    public List<String> fieldList { get; set; }
    public List<Doctor__c> doctors { get; set; }


    public Hosp_DoctorImportController() {
        csvFileLines = new String[]{
        };
        fieldList = New List<string>();
        doctors = New List<Doctor__c>();
    }

    public void importCSVFile() {
        // UTF-8
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        inputValues = new String[]{
        };

        for (string st : csvFileLines[0].split(','))
            fieldList.add(st);

        for (Integer i = 1; i < csvFileLines.size(); i++) {
            Doctor__c doc = new Doctor__c(Name = '') ;
            string[] csvRecordData = csvfilelines[i].split(',');
            doc.Name = csvRecordData[0] ;
            doc.FirstName__c = csvRecordData[1];
            doc.City__c = csvRecordData[2];
            doc.Country__c = csvRecordData[3];

            doctors.add(doc);
        }
    }

    public void importDoctors() {

    }

    public void clear() {

    }
}