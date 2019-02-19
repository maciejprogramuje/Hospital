public with sharing class Hosp_DoctorSearchController {
    public Doctor__c currentDoctor { get; set; }
    public String currentDoctorId { get; set; }
    public List<Doctor__c> doctorsToExport { get; set; }
    public String doctorsInJson { get; set; }
    //private Integer paginationSize = 5;
    private Integer paginationSize = 500;

    public static final String sortUp = '▲';
    public static final String sortDown = '▼';
    private String sortOrder = 'Name';
    private String sortAscDesc = 'ASC';
    public String sortOrderSignName { get; set; }
    public String sortOrderSignEmail { get; set; }
    public String sortOrderSignCountry { get; set; }
    public String sortOrderSign { get; set; }

    public ApexPages.StandardSetController stdSetController {
        get {
            if (stdSetController == null) {
                if (String.isNotBlank(currentDoctor.Name)) {
                    stdSetController = new ApexPages.StandardSetController(fillDoctorsLists());
                    stdSetController.setPageSize(paginationSize);
                } else {
                    stdSetController = new ApexPages.StandardSetController(new List<Doctor__c>());
                }
            }
            return stdSetController;
        }
        set;
    }

    public Hosp_DoctorSearchController() {
        currentDoctor = new Doctor__c(Name = '');
        doctorsToExport = new List<Doctor__c>();

        sortOrderSign = sortDown;
        sortOrderSignName = sortOrderSign;
    }

    public List<Doctor__c> getCurrentDoctors() {
        return stdSetController.getRecords();
    }

    public List<Doctor__c> fillDoctorsLists() {
        String queryDoctor = Hosp_Utils.doctorQueryBuilder(currentDoctor, sortOrder, sortAscDesc);
        doctorsToExport = Database.query(queryDoctor);
        return Database.query(queryDoctor);
    }

    public void search() {
        stdSetController = null;
    }

    public Boolean hasNext {
        get {
            return stdSetController.getHasNext();
        }
        set;
    }

    public Boolean hasPrevious {
        get {
            return stdSetController.getHasPrevious();
        }
        set;
    }

    public Integer pageNumber {
        get {
            return stdSetController.getPageNumber();
        }
        set;
    }

    public void first() {
        stdSetController.first();
    }

    public void last() {
        stdSetController.last();
    }

    public void previous() {
        stdSetController.previous();
    }

    public void next() {
        stdSetController.next();
    }

    public void cancel() {
        stdSetController.cancel();
    }

    public void clear() {
        currentDoctor = new Doctor__c(Name = '');
        doctorsToExport = new List<Doctor__c>();
        stdSetController = null;
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
        PageReference pageReference = Page.Hosp_DoctorsSearchCsvExport;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public PageReference expToXls() {
        PageReference pageReference = Page.Hosp_DoctorsSearchXlsExport;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public PageReference expToXlsx() {
        PageReference pageReference = Page.Hosp_DoctorsSearchXlsxExport;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public PageReference expToJson() {
        PageReference pageReference = Page.Hosp_DoctorSearchJsonExport;
        pageReference.setRedirect(false);
        return pageReference;
    }

    public void generateDoctorsInJson() {
        doctorsInJson = Hosp_DoctorJsonHandler.getDoctorsInJson(doctorsToExport);
    }
}