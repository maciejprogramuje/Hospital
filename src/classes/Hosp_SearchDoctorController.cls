public with sharing class Hosp_SearchDoctorController {
    public Doctor__c doctor { get; set; }
    public String docId { get; set; }

    private String sortOrder = 'FirstName__c';
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

    public ApexPages.StandardSetController ssController { get{
        if(ssController == null) {
            ssController = new ApexPages.StandardSetController(Database.query(queryString()));
            ssController.setPageSize(5);
        }
        return ssController;
    } set; }

    public List<Doctor__c> getDoctors() {
        return ssController.getRecords();
    }

    public String queryString() {
        String queryDoctor = 'SELECT Id, Name FROM Doctor__c WHERE Name =\'XXXXXXX\'';
        if(String.isNotBlank(doctor.Name)) {
            queryDoctor = 'SELECT Id, Name, FirstName__c, Email__c, Country__c FROM Doctor__c WHERE Name LIKE \'' + doctor.Name + '%\'';
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
        }
        return queryDoctor;
    }


    public void search() {
        ssController = null;
    }

    public Boolean hasNext {
        get {
            return ssController.getHasNext();
        }
        set;
    }

    public Boolean hasPrevious {
        get {
            return ssController.getHasPrevious();
        }
        set;
    }

    public Integer pageNumber {
        get {
            return ssController.getPageNumber();
        }
        set;
    }

    public void first() {
        ssController.first();
    }

    public void last() {
        ssController.last();
    }

    public void previous() {
        ssController.previous();
    }

    public void next() {
        ssController.next();
    }

    public void cancel() {
        ssController.cancel();
    }

    public void clear() {
        doctor.FirstName__c = '';
        doctor.Name = '';
        doctor.Email__c = '';
        doctor.Country__c = null;

        ssController = null;
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

    public PageReference expToCsv() {
        PageReference pageReference = Page.Hosp_SearchDoctorsCsvExport;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public PageReference expToXls() {
        PageReference pageReference = Page.Hosp_SearchDoctorsXlsExport;
        pageReference.setRedirect(false);
        return pageReference;
    }

}
