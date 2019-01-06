public with sharing class Hosp_PiotrDoctorsController {
    public Doctor__c doctorToSearch { get; set; }
    public Doctor__c doctorToEdit { get; set; }
    public Doctor__c doctorToInsert { get; set; }
    public String doctorToEditId { get; set; }
    public Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP doctorsService { get; set; }
    public List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctorsResults { get; set; }

    public Boolean isAnyDoctorInResultsList { get; set; }
    public Boolean isAnyProblemWithDelete { get; set; }
    public Boolean isAnyInsertProblem { get; set; }
    public String messageSuccessToast { get; set; }
    public String messageErrorToast { get; set; }


    public Hosp_PiotrDoctorsController() {
        doctorsService = new Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP();
        doctorToSearch = new Doctor__c();
        doctorToEdit = new Doctor__c();
        doctorToInsert = new Doctor__c();
        doctorsService.timeout_x = 1000;
        doctorsService.SessionHeader = new Hosp_soapSforceComSchemasClassHospitalD.SessionHeader_element();
        doctorsService.SessionHeader.sessionId = loginToPiotr();

        doctorsResults = new List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP>();

        isAnyDoctorInResultsList = false;
        isAnyProblemWithDelete = false;
        isAnyInsertProblem = true;
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
        clearMessages();

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

        Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctorToUpsert = doctorsService.upsertDoctor(doctorToEdit.Id, doctorToEdit.FirstName__c, doctorToEdit.Name, doctorToEdit.City__c, doctorToEdit.Country__c);

        refreshResultsList(doctorToUpsert);
    }

    public void insertDoctor() {
        clearMessages();

        try {
            Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctorToUpsert = doctorsService.upsertDoctor(doctorToInsert.Id, doctorToInsert.FirstName__c, doctorToInsert.Name, doctorToInsert.City__c, doctorToInsert.Country__c);
            isAnyInsertProblem = false;
            refreshResultsList(doctorToUpsert);
        } catch (Exception e) {
            isAnyInsertProblem = true;

            System.debug('isAnyInsertProblem='+e.getMessage());
        }
    }

    private void refreshResultsList(Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctor) {
        if (doctor != null
                && (String.isNotBlank(doctorToSearch.Name)
                || String.isNotBlank(doctorToSearch.FirstName__c)
                || String.isNotBlank(doctorToSearch.City__c)
                || String.isNotBlank(doctorToSearch.Country__c))) {
            doctorToEditId = doctor.webServiceDoctorId;

            searchDoctors();
        }
    }

    public void resetDoctorToInsert() {
        clearMessages();
        isAnyInsertProblem = true;
        doctorToInsert = new Doctor__c();
    }

    public void clearMessages() {
        ApexPages.getMessages().clear();
    }

    public void deleteDoctor() {
        clearMessages();

        try {
            List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> deletedDoctors = doctorsService.deleteDoctors(new List<String>{
                    doctorToEditId
            });
            isAnyProblemWithDelete = false;
            messageSuccessToast = 'Doctor successfully deleted';
            searchDoctors();
        } catch (Exception e) {
            isAnyProblemWithDelete = true;
            messageErrorToast = 'Unable to delete doctor';
        }
    }

    private String loginToPiotr() {
        try {
            Hosp_partnerSoapSforceCom.Soap partnerSoap = new Hosp_partnerSoapSforceCom.Soap();
            Hosp_partnerSoapSforceCom.LoginResult loginResult = partnerSoap.login(Label.Hosp_login_to_Piotr, Label.Hosp_password_to_Piotr);
            return loginResult.sessionId;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            return null;
        }
    }
}