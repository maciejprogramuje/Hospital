public with sharing class Hosp_SearchDoctorController {
    public Doctor__c doctor { get; set; }
    public List<Doctor__c> doctors { get; set; }
    public String docId { get; set; }
    private String sortOrder = 'Name, FirstName__c';
    private String sortAscDesc = 'ASC';
    public static final String sortUp = '▲';
    public static final String sortDown = '▼';
    public String sortOrderSignName { get; set; }
    public String sortOrderSignEmail { get; set; }
    public String sortOrderSignCountry { get; set; }
    public String sortOrderSign { get; set; }

    public Hosp_SearchDoctorController() {
        doctor = new Doctor__c(Name = '');

        sortOrderSign = sortDown;
        sortOrderSignName = sortOrderSign;
    }

    public void search() {
        String queryDoctor = 'SELECT Id, Name, FirstName__c, Email__c, Country__c FROM Doctor__c WHERE Name LIKE \'' + doctor.Name + '%\'';
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
        doctors = Database.query(queryDoctor);
    }

    public void clear() {
        doctor.FirstName__c = '';
        doctor.Name = '';
        doctor.Email__c = '';
        doctor.Country__c = null;

        doctors = null;
    }

    public void sortByCountry() {
        sortBy('Country__c');
        clearOrderSigns();
        sortOrderSignCountry = sortOrderSign;
    }

    public void sortByEmail() {
        sortBy('Email__c');
        clearOrderSigns();
        sortOrderSignEmail = sortOrderSign;
    }

    public void sortByName() {
        sortBy('Name, FirstName__c');
        clearOrderSigns();
        sortOrderSignName = sortOrderSign;
    }

    private void sortBy(String sortBy) {
        flipSortAscDesc();
        sortOrder = sortBy;
        search();
    }

    private void flipSortAscDesc() {
        if (sortAscDesc.equals('ASC')) {
            sortAscDesc = 'DESC';
            sortOrderSign = sortUp;
        } else {
            sortAscDesc = 'ASC';
            sortOrderSign = sortDown;
        }
    }

    private void clearOrderSigns() {
        sortOrderSignName = '';
        sortOrderSignEmail = '';
        sortOrderSignCountry = '';
    }
}
