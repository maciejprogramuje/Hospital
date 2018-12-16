public with sharing class Hosp_SearchDoctorController {
    public Doctor__c doctor { get; set; }
    public String docId { get; set; }
    public List<Doctor__c> doctorsToExport { get; set; }
    private Integer paginationSize = 5;

    private String sortOrder = 'Name';
    private String sortAscDesc = 'ASC';
    public static final String sortUp = '▲';
    public static final String sortDown = '▼';
    public String sortOrderSignName { get; set; }
    public String sortOrderSignEmail { get; set; }
    public String sortOrderSignCountry { get; set; }
    public String sortOrderSign { get; set; }

    public ApexPages.StandardSetController ssController {
        get {
            if (ssController == null) {
                if (String.isNotBlank(doctor.Name)) {
                    ssController = new ApexPages.StandardSetController(fillDoctorsLists());
                    ssController.setPageSize(paginationSize);
                } else {
                    ssController = new ApexPages.StandardSetController(new List<Doctor__c>());
                }
            }
            return ssController;
        }
        set;
    }

    public Hosp_SearchDoctorController() {
        doctor = new Doctor__c(Name = '');
        doctorsToExport = new List<Doctor__c>();

        sortOrderSign = sortDown;
        sortOrderSignName = sortOrderSign;
    }

    public List<Doctor__c> getDoctors() {
        return ssController.getRecords();
    }

    public List<Doctor__c> fillDoctorsLists() {
        String queryDoctor = Hosp_Utils.doctorQueryBuilder(doctor, sortOrder, sortAscDesc);
        doctorsToExport = Database.query(queryDoctor);
        return Database.query(queryDoctor);
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
        sortBy('Name');
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

    public PageReference expToXlsx() {
        PageReference pageReference = Page.Hosp_SearchDoctorsXlsxExport;
        pageReference.setRedirect(false);
        return pageReference;
    }
}
