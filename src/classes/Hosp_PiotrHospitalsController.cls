public with sharing class Hosp_PiotrHospitalsController {
    public Hosp_PiotrHospitalsControllerHandler handler { get; set; }
    public Hospital__c hospitalToSearch { get; set; }
    public Hospital__c hospitalToEdit { get; set; }
    public String hospitalToEditId { get; set; }

    public Boolean isAnyProblemWithDelete { get; set; }
    public Boolean isAnyUpsertProblem { get; set; }

    public List<Hosp_HospitalWrapperForRest> hospitalsResults { get; set; }

    public Boolean sortAsc { get; set; }
    public String showSortByNameSignAsc { get; set; }
    public String showSortByNameSignDesc { get; set; }
    public String showSortByCitySignAsc { get; set; }
    public String showSortByCitySignDesc { get; set; }
    public String showSortByCountrySignAsc { get; set; }
    public String showSortByCountrySignDesc { get; set; }

    public Hosp_PiotrHospitalsController() {
        handler = new Hosp_PiotrHospitalsControllerHandler();

        hospitalsResults = new List<Hosp_HospitalWrapperForRest>();
        hospitalToSearch = new Hospital__c();
        hospitalToEdit = new Hospital__c();

        isAnyProblemWithDelete = false;
        isAnyUpsertProblem = true;

        sortAsc = true;
        hideAllSortOrderSigns();
    }

    public void searchHospitals() {
        clearMessages();

        hospitalsResults = handler.getHospitalCallout(hospitalToSearch.Name, hospitalToSearch.City__c, hospitalToSearch.Country__c);

        sortAsc = true;
        sortByName();
    }

    public void deleteHospital() {
        clearMessages();

        try {
            List<Hosp_HospitalWrapperForRest> deletedHospitals = handler.deleteHospitalCallout(hospitalToEditId);
            isAnyProblemWithDelete = false;
            Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Hospital_successfully_deleted;
            searchHospitals();
        } catch (Exception e) {
            isAnyProblemWithDelete = true;
            Hosp_ErrorToastController.messageErrorToast = Label.Hosp_Unable_to_delete_hospital;
            System.debug('isAnyProblemWithDelete=' + e.getMessage());
        }
    }

    public void upsertHospital() {
        clearMessages();

        try {
            List<Hosp_HospitalWrapperForRest> upsertedHospitals = handler.upsertHospitalCallout(hospitalToEdit);
            isAnyUpsertProblem = false;
            Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Hospital_successfully_updated;
            refreshResultsList(upsertedHospitals);
        } catch (Exception e) {
            isAnyUpsertProblem = true;
            Hosp_ErrorToastController.messageErrorToast = e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Hosp_UtilsConvertErrorMessages.convert(e.getMessage())));
            System.debug('isAnyUpsertProblem=' + e);
        }
    }

    public void resetHospitalToUpsert() {
        clearMessages();
        isAnyUpsertProblem = true;
        hospitalToEdit = new Hospital__c();
    }

    public void openHospitalToEdit() {
        resetHospitalToUpsert();

        for (Hosp_HospitalWrapperForRest hosp : hospitalsResults) {
            if (hosp.hospitalId == hospitalToEditId) {
                hospitalToEdit.Id = hosp.hospitalId;
                hospitalToEdit.Name = hosp.name;
                hospitalToEdit.City__c = hosp.city;
                hospitalToEdit.Country__c = hosp.country;
                break;
            }
        }
    }

    private void refreshResultsList(List<Hosp_HospitalWrapperForRest> hospitals) {
        if (!hospitals.isEmpty()
                && (String.isNotBlank(hospitalToSearch.Name)
                || String.isNotBlank(hospitalToSearch.City__c)
                || String.isNotBlank(hospitalToSearch.Country__c))) {
            hospitalToEditId = hospitals.get(0).hospitalId;

            searchHospitals();
        }
    }

    public void clearMessages() {
        ApexPages.getMessages().clear();
    }

    public void sortByName() {
        hideAllSortOrderSigns();

        if (sortAsc) {
            showSortByNameSignAsc = 'display-block';
            showSortByNameSignDesc = 'none';
        } else {
            showSortByNameSignAsc = 'none';
            showSortByNameSignDesc = 'display-block';
        }

        Hosp_HospitalsSorting.compareBy = 'name';
        hospitalsResults = Hosp_HospitalsSorting.sortResults(hospitalsResults, sortAsc);

        flipSortOrder();
    }

    public void sortByCity() {
        hideAllSortOrderSigns();

        if (sortAsc) {
            showSortByCitySignAsc = 'display-block';
            showSortByCitySignDesc = 'none';
        } else {
            showSortByCitySignAsc = 'none';
            showSortByCitySignDesc = 'display-block';
        }

        Hosp_HospitalsSorting.compareBy = 'city';
        hospitalsResults = Hosp_HospitalsSorting.sortResults(hospitalsResults, sortAsc);

        flipSortOrder();
    }

    public void sortByCountry() {
        hideAllSortOrderSigns();

        if (sortAsc) {
            showSortByCountrySignAsc = 'display-block';
            showSortByCountrySignDesc = 'none';
        } else {
            showSortByCountrySignAsc = 'none';
            showSortByCountrySignDesc = 'display-block';
        }

        Hosp_HospitalsSorting.compareBy = 'country';
        hospitalsResults = Hosp_HospitalsSorting.sortResults(hospitalsResults, sortAsc);

        flipSortOrder();
    }

    private void flipSortOrder() {
        sortAsc = !sortAsc;
    }

    private void hideAllSortOrderSigns() {
        showSortByNameSignAsc = 'none';
        showSortByNameSignDesc = 'none';
        showSortByCitySignAsc = 'none';
        showSortByCitySignDesc = 'none';
        showSortByCountrySignAsc = 'none';
        showSortByCountrySignDesc = 'none';
    }
}

