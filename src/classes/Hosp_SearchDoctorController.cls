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
        String firstName = doctor.FirstName__c;
        String lastName = doctor.Name;
        String email = doctor.Email__c;
        String country = doctor.Country__c;

        String queryDoctor = 'SELECT Id, Name, FirstName__c, Email__c, Country__c FROM Doctor__c WHERE Name = \'' + lastName + '\'';
        if (String.isNotBlank(firstName)) {
            queryDoctor += ' AND FirstName__c = \'' + firstName + '\'';
        }
        if (String.isNotBlank(email)) {
            queryDoctor += ' AND Email__c = \'' + email + '\'';
        }
        if (String.isNotBlank(country)) {
            queryDoctor += ' AND Country__c = \'' + country + '\'';
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
