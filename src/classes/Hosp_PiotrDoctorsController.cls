public with sharing class Hosp_PiotrDoctorsController {
    public Doctor__c doctorToSearch { get; set; }
    public Doctor__c doctorToEdit { get; set; }
    public String doctorToEditId { get; set; }
    public Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP doctorsService { get; set; }
    public List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctorsResults { get; set; }

    public List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> deletedDoctorsToTest { get; set; }
    public Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctorToTest { get; set; }

    public Boolean isAnyDoctorInResultsList { get; set; }
    public Boolean isAnyProblemWithDelete { get; set; }
    public Boolean isAnyUpsertProblem { get; set; }

    public Hosp_PiotrDoctorsController() {
        doctorsService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();
        doctorToSearch = new Doctor__c();
        doctorToEdit = new Doctor__c();
        //doctorToInsert = new Doctor__c();
        doctorsService.timeout_x = 1000;
        doctorsService.SessionHeader = new Hosp_soapSforceComSchemasClassHospitalD.SessionHeader_element();
        doctorsService.SessionHeader.sessionId = Hosp_Utils.loginToPiotrGetSessionId();
        doctorsResults = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();

        isAnyDoctorInResultsList = false;
        isAnyProblemWithDelete = false;
        isAnyUpsertProblem = true;
    }

    public void searchDoctors() {
        clearMessages();

        doctorsResults = doctorsService.getDoctors(doctorToSearch.FirstName__c, doctorToSearch.Name, doctorToSearch.City__c, doctorToSearch.Country__c);

        if (doctorsResults != null) {
            isAnyDoctorInResultsList = true;
        } else {
            isAnyDoctorInResultsList = false;
        }
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
            doctorToTest = doctorsService.upsertDoctor(doctorToEdit.Id, doctorToEdit.FirstName__c, doctorToEdit.Name, doctorToEdit.City__c, doctorToEdit.Country__c);
            isAnyUpsertProblem = false;
            Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Doctor_successfully_updated;
            refreshResultsList(doctorToTest);
        } catch (Exception e) {
            isAnyUpsertProblem = true;
            Hosp_ErrorToastController.messageErrorToast = Label.Hosp_Unable_to_update_doctor;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
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
            deletedDoctorsToTest = doctorsService.deleteDoctors(new List<String>{doctorToEditId});
            isAnyProblemWithDelete = false;
            Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Doctor_successfully_deleted;
            if (!Test.isRunningTest()) {
                searchDoctors();
            }
        } catch (Exception e) {
            isAnyProblemWithDelete = true;
            Hosp_ErrorToastController.messageErrorToast = Label.Hosp_Unable_to_delete_doctor;
        }
    }

}