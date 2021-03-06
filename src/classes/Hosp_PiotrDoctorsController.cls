public with sharing class Hosp_PiotrDoctorsController {
    public Hosp_PiotrDoctorsControllerHandler handler { get; set; }

    public Doctor__c doctorToSearch { get; set; }
    public Doctor__c doctorToEdit { get; set; }
    public String doctorToEditId { get; set; }
    public List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctorsResults { get; set; }
    public List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> deletedDoctorsToTest { get; set; }
    public Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctorToTest { get; set; }

    public Boolean isAnyDoctorInResultsList { get; set; }
    public Boolean isAnyProblemWithDelete { get; set; }
    public Boolean isAnyUpsertProblem { get; set; }

    public Boolean sortAsc { get; set; }
    public String showSortByNameSignAsc { get; set; }
    public String showSortByNameSignDesc { get; set; }
    public String showSortByFirstNameSignAsc { get; set; }
    public String showSortByFirstNameSignDesc { get; set; }
    public String showSortByCitySignAsc { get; set; }
    public String showSortByCitySignDesc { get; set; }
    public String showSortByCountrySignAsc { get; set; }
    public String showSortByCountrySignDesc { get; set; }


    public Hosp_PiotrDoctorsController() {
        handler = new Hosp_PiotrDoctorsControllerHandler();

        doctorToSearch = new Doctor__c();
        doctorToEdit = new Doctor__c();

        isAnyDoctorInResultsList = false;
        isAnyProblemWithDelete = false;
        isAnyUpsertProblem = true;

        sortAsc = true;
        hideAllSortOrderSigns();
    }

    public void searchDoctors() {
        clearMessages();

        try {
            handler.generateDoctorServiceFromCache();
            doctorsResults = handler.doctorsService.getDoctors(doctorToSearch.FirstName__c, doctorToSearch.Name, doctorToSearch.City__c, doctorToSearch.Country__c);
        } catch (Exception e) {
            handler.generateDoctorServiceFromSoap();
            doctorsResults = handler.doctorsService.getDoctors(doctorToSearch.FirstName__c, doctorToSearch.Name, doctorToSearch.City__c, doctorToSearch.Country__c);
        }

        sortAsc = true;
        sortByName();
    }

    public void openDoctorToEdit() {
        resetDoctorToUpsert();

        for (Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doc : doctorsResults) {
            if (doc.webServiceDoctorId == doctorToEditId) {
                doctorToEdit.Id = doc.webServiceDoctorId;
                doctorToEdit.Name = doc.webServiceDoctorLastName;
                doctorToEdit.FirstName__c = doc.webServiceDoctorFirstName;
                doctorToEdit.City__c = doc.webServiceDoctorCity;
                doctorToEdit.Country__c = doc.webServiceDoctorCountry;
                break;
            }
        }
    }

    public void upsertDoctor() {
        clearMessages();

        try {
            try {
                handler.generateDoctorServiceFromCache();
                doctorToTest = handler.doctorsService.upsertDoctor(doctorToEdit.Id, doctorToEdit.FirstName__c, doctorToEdit.Name, doctorToEdit.City__c, doctorToEdit.Country__c);
                isAnyUpsertProblem = false;
                Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Doctor_successfully_updated;
                refreshResultsList(doctorToTest);
            } catch (Exception ex) {
                handler.generateDoctorServiceFromSoap();
                doctorToTest = handler.doctorsService.upsertDoctor(doctorToEdit.Id, doctorToEdit.FirstName__c, doctorToEdit.Name, doctorToEdit.City__c, doctorToEdit.Country__c);
                isAnyUpsertProblem = false;
                Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Doctor_successfully_updated;
                refreshResultsList(doctorToTest);
            }
        } catch (Exception e) {
            isAnyUpsertProblem = true;
            Hosp_ErrorToastController.messageErrorToast = Label.Hosp_Unable_to_update_doctor;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Hosp_UtilsConvertErrorMessages.convert(e.getMessage())));
            System.debug('isAnyUpsertProblem=' + e.getMessage());
        }

    }

    private void refreshResultsList(Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctor) {
        if (doctor != null
                && (String.isNotBlank(doctorToSearch.Name)
                || String.isNotBlank(doctorToSearch.FirstName__c)
                || String.isNotBlank(doctorToSearch.City__c)
                || String.isNotBlank(doctorToSearch.Country__c))) {
            doctorToEditId = doctor.webServiceDoctorId;

            if (!Test.isRunningTest()) {
                searchDoctors();
            }
        }
    }

    public void resetDoctorToUpsert() {
        clearMessages();
        isAnyUpsertProblem = true;
        doctorToEdit = new Doctor__c();
    }

    public void clearMessages() {
        ApexPages.getMessages().clear();
    }

    public void deleteDoctor() {
        clearMessages();

        try {
            try {
                handler.generateDoctorServiceFromCache();
                deletedDoctorsToTest = handler.doctorsService.deleteDoctors(new List<String>{doctorToEditId});
                isAnyProblemWithDelete = false;
                Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Doctor_successfully_deleted;
                if (!Test.isRunningTest()) {
                    searchDoctors();
                }
            } catch (Exception ex) {
                handler.generateDoctorServiceFromSoap();
                deletedDoctorsToTest = handler.doctorsService.deleteDoctors(new List<String>{doctorToEditId});
                isAnyProblemWithDelete = false;
                Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Doctor_successfully_deleted;
                if (!Test.isRunningTest()) {
                    searchDoctors();
                }
            }
        } catch (Exception e) {
            isAnyProblemWithDelete = true;
            Hosp_ErrorToastController.messageErrorToast = Label.Hosp_Unable_to_delete_doctor;
            System.debug(e.getMessage());
        }
    }

    public void sortByName() {
        hideAllSortOrderSigns();

        if(sortAsc){
            showSortByNameSignAsc = 'display-block';
            showSortByNameSignDesc = 'none';
        } else {
            showSortByNameSignAsc = 'none';
            showSortByNameSignDesc = 'display-block';
        }

        Hosp_DoctorsSorting.compareBy = 'name';
        doctorsResults = Hosp_DoctorsSorting.sortResults(doctorsResults, sortAsc);

        flipSortOrder();
    }

    public void sortByFirstName() {
        hideAllSortOrderSigns();

        if(sortAsc){
            showSortByFirstNameSignAsc = 'display-block';
            showSortByFirstNameSignDesc = 'none';
        } else {
            showSortByFirstNameSignAsc = 'none';
            showSortByFirstNameSignDesc = 'display-block';
        }

        Hosp_DoctorsSorting.compareBy = 'firstName';
        doctorsResults = Hosp_DoctorsSorting.sortResults(doctorsResults, sortAsc);

        flipSortOrder();
    }

    public void sortByCity() {
        hideAllSortOrderSigns();

        if(sortAsc){
            showSortByCitySignAsc = 'display-block';
            showSortByCitySignDesc = 'none';
        } else {
            showSortByCitySignAsc = 'none';
            showSortByCitySignDesc = 'display-block';
        }

        Hosp_DoctorsSorting.compareBy = 'city';
        doctorsResults = Hosp_DoctorsSorting.sortResults(doctorsResults, sortAsc);

        flipSortOrder();
    }

    public void sortByCountry() {
        hideAllSortOrderSigns();

        if(sortAsc){
            showSortByCountrySignAsc = 'display-block';
            showSortByCountrySignDesc = 'none';
        } else {
            showSortByCountrySignAsc = 'none';
            showSortByCountrySignDesc = 'display-block';
        }

        Hosp_DoctorsSorting.compareBy = 'country';
        doctorsResults = Hosp_DoctorsSorting.sortResults(doctorsResults, sortAsc);

        flipSortOrder();
    }

    private void flipSortOrder() {
        sortAsc = !sortAsc;
    }

    private void hideAllSortOrderSigns() {
        showSortByNameSignAsc = 'none';
        showSortByNameSignDesc = 'none';
        showSortByFirstNameSignAsc = 'none';
        showSortByFirstNameSignDesc = 'none';
        showSortByCitySignAsc = 'none';
        showSortByCitySignDesc = 'none';
        showSortByCountrySignAsc = 'none';
        showSortByCountrySignDesc = 'none';
    }
}
