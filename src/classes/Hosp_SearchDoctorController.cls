public with sharing class Hosp_SearchDoctorController {
    public Doctor__c doctor { get; set; }
    public String docId { get; set; }
    public Integer noOfRecords { get; set; }
    public Integer size { get; set; }

    private String sortOrder = 'Name, FirstName__c';
    private String sortAscDesc = 'ASC';

    public Hosp_SearchDoctorController() {
        doctor = new Doctor__c(Name = '');
        size = 5;
    }

    public ApexPages.StandardSetController standardSetController {
        get {
            if (standardSetController == null) {
                standardSetController = new ApexPages.StandardSetController(populateDoctors());
                standardSetController.setPageSize(size);
                noOfRecords = standardSetController.getResultSize();
            }
            return standardSetController;
        }
        set;
    }

    public List<Doctor__c> getDoctors() {
        return (List<Doctor__c>) standardSetController.getRecords();
    }

    public List<Doctor__c> populateDoctors() {
        String queryDoctor = 'SELECT Id, Name, FirstName__c, Email__c, Country__c, FirstLastName__c FROM Doctor__c WHERE Name LIKE \'' + doctor.Name + '%\'';
        if (String.isNotBlank(doctor.FirstName__c)) {
            queryDoctor += ' AND FirstName__c LIKE \'' + doctor.FirstName__c + '%\'';
        }
        if (String.isNotBlank(doctor.Email__c)) {
            queryDoctor += ' AND Email__c LIKE \'' + doctor.Email__c + '%\'';
        }
        if (String.isNotBlank(doctor.Country__c)) {
            queryDoctor += ' AND Country__c LIKE \'' + doctor.Country__c + '%\'';
        }
        queryDoctor = queryDoctor + ' ORDER BY ' + sortOrder + ' ' + sortAscDesc;
        return Database.query(queryDoctor);
    }

    public void search() {

    }

    public void clear() {
        //doctors = null;
    }

    public Boolean hasNext {
        get {
            return standardSetController.getHasNext();
        }
        set;
    }

    public Boolean hasPrevious {
        get {
            return standardSetController.getHasPrevious();
        }
        set;
    }

    public Integer pageNumber {
        get {
            return standardSetController.getPageNumber();
        }
        set;
    }

    public void first() {
        standardSetController.first();
    }

    public void last() {
        standardSetController.last();
    }

    public void previous() {
        standardSetController.previous();
    }

    public void next() {
        standardSetController.next();
    }

    public void cancel() {
        standardSetController.cancel();
    }

}
