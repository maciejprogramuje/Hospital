public with sharing class Hosp_PiotrHospitalsController {
    public Hospital__c hospitalToSearch { get; set; }
    public Hospital__c hospitalToEdit { get; set; }
    public Hospital__c hospitalToInsert { get; set; }
    public String hospitalToEditId { get; set; }
    //public Hosp_soapSforceComSchemasClassHospitalD.Hospital_DoctorsSOAP hospitalService { get; set; }

    public Boolean isAnyHospitalInResultsList { get; set; }
    public Boolean isAnyProblemWithDelete { get; set; }
    public Boolean isAnyInsertProblem { get; set; }
    public Boolean isAnyUpdateProblem { get; set; }
    public String messageSuccessToast { get; set; }
    public String messageErrorToast { get; set; }


    public String endPoint = 'https://eu16.salesforce.com/services/apexrest/Hospital__c/';
    public List<Hosp_HospitalWrapperForRest> hospitalsResults { get; set; }

    public Hosp_PiotrHospitalsController(){
        hospitalsResults = new List<Hosp_HospitalWrapperForRest>();
        hospitalToSearch = new Hospital__c();
        hospitalToEdit = new Hospital__c();
        hospitalToInsert = new Hospital__c();


        isAnyHospitalInResultsList = false;
        isAnyProblemWithDelete = false;
        isAnyInsertProblem = true;
        isAnyUpdateProblem = true;
    }

    public HttpRequest getRequest(String methodType, String urlParams, String body){
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint + urlParams);
        request.setHeader('Authorization', 'Bearer ' + loginToPiotr());
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod(methodType);
        if (body != '') {
            request.setBody(body);
        }
        return request;
    }

    public List<Hosp_HospitalWrapperForRest> getHospitalCallout(String query){
        Http http = new Http();
        HttpRequest request = getRequest('GET',query,'');
        HttpResponse response = http.send(request);
        List<Hosp_HospitalWrapperForRest> hospitalList = (List<Hosp_HospitalWrapperForRest>) JSON.deserializeStrict(response.getBody(), List<Hosp_HospitalWrapperForRest>.class);

        return hospitalList;
    }

    public void searchHospitals(){
        hospitalsResults = getHospitalCallout(hospitalToSearch.Name);

        if (hospitalsResults != null) {
            isAnyHospitalInResultsList = true;
        } else {
            isAnyHospitalInResultsList = false;
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





    public void resetHospitalToInsert() {
        /*clearMessages();
        isAnyInsertProblem = true;
        doctorToInsert = new Doctor__c();*/
    }

    public void openHospitalToEdit() {
        /*resetDoctorToUpdate();

        for (Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doc : doctorsResults) {
            if (doc.webServiceDoctorId == doctorToEditId) {
                doctorToEdit.Id = doc.webServiceDoctorId;
                doctorToEdit.Name = doc.webServiceDoctorLastName;
                doctorToEdit.FirstName__c = doc.webServiceDoctorFirstName;
                doctorToEdit.City__c = doc.webServiceDoctorCity;
                doctorToEdit.Country__c = doc.webServiceDoctorCountry;
                break;
            }
        }*/
    }

    public void deleteHospital() {
        /*clearMessages();

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
        }*/
    }

    public void updateHospital() {
        /*clearMessages();

        try {
            Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctor = doctorsService.upsertDoctor(doctorToEdit.Id, doctorToEdit.FirstName__c, doctorToEdit.Name, doctorToEdit.City__c, doctorToEdit.Country__c);
            isAnyUpdateProblem = false;
            refreshResultsList(doctor);
        } catch (Exception e) {
            isAnyUpdateProblem = true;
            System.debug('isAnyUpdateProblem=' + e.getMessage());
        }*/
    }

    public void resetHospitalToUpdate() {
        /*clearMessages();
        isAnyUpdateProblem = true;
        doctorToEdit = new Doctor__c();*/
    }

    public void insertHospital() {
        /*clearMessages();

        try {
            Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctor = doctorsService.upsertDoctor(doctorToInsert.Id, doctorToInsert.FirstName__c, doctorToInsert.Name, doctorToInsert.City__c, doctorToInsert.Country__c);
            isAnyInsertProblem = false;
            refreshResultsList(doctor);
        } catch (Exception e) {
            isAnyInsertProblem = true;
            System.debug('isAnyInsertProblem=' + e.getMessage());
        }*/
    }

}













    /*public Hosp_PiotrHospitalsController() {
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
        isAnyUpdateProblem = true;
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
        resetDoctorToUpdate();

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

    public void updateDoctor() {
        clearMessages();

        try {
            Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctor = doctorsService.upsertDoctor(doctorToEdit.Id, doctorToEdit.FirstName__c, doctorToEdit.Name, doctorToEdit.City__c, doctorToEdit.Country__c);
            isAnyUpdateProblem = false;
            refreshResultsList(doctor);
        } catch (Exception e) {
            isAnyUpdateProblem = true;
            System.debug('isAnyUpdateProblem=' + e.getMessage());
        }

    }

    public void insertDoctor() {
        clearMessages();

        try {
            Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctor = doctorsService.upsertDoctor(doctorToInsert.Id, doctorToInsert.FirstName__c, doctorToInsert.Name, doctorToInsert.City__c, doctorToInsert.Country__c);
            isAnyInsertProblem = false;
            refreshResultsList(doctor);
        } catch (Exception e) {
            isAnyInsertProblem = true;
            System.debug('isAnyInsertProblem=' + e.getMessage());
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

    public void resetDoctorToUpdate() {
        clearMessages();
        isAnyUpdateProblem = true;
        doctorToEdit = new Doctor__c();
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
    }*/
