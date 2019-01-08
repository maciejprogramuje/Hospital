public with sharing class Hosp_PiotrHospitalsController {
    public Hospital__c hospitalToSearch { get; set; }
    public Hospital__c hospitalToEdit { get; set; }
    public Hospital__c hospitalToInsert { get; set; }
    public String hospitalToEditId { get; set; }

    public Boolean isAnyHospitalInResultsList { get; set; }
    public Boolean isAnyProblemWithDelete { get; set; }
    public Boolean isAnyInsertProblem { get; set; }
    public Boolean isAnyUpdateProblem { get; set; }

    public String endPoint = Label.Hosp_Endpoint_Piotr_Hospital;
    public List<Hosp_HospitalWrapperForRest> hospitalsResults { get; set; }

    public Hosp_PiotrHospitalsController() {
        hospitalsResults = new List<Hosp_HospitalWrapperForRest>();
        hospitalToSearch = new Hospital__c();
        hospitalToEdit = new Hospital__c();
        hospitalToInsert = new Hospital__c();

        isAnyHospitalInResultsList = false;
        isAnyProblemWithDelete = false;
        isAnyInsertProblem = true;
        isAnyUpdateProblem = true;
    }

    public void searchHospitals() {
        /*
        if(String.isNotBlank(hospitalToSearch.Name)
                || )*/

        hospitalsResults = getHospitalCallout(hospitalToSearch.Name, hospitalToSearch.City__c, hospitalToSearch.Country__c);

        if (hospitalsResults.size() > 0) {
            isAnyHospitalInResultsList = true;
        } else {
            isAnyHospitalInResultsList = false;
        }
    }

    public List<Hosp_HospitalWrapperForRest> getHospitalCallout(String queryName, String queryCity, String queryCountry) {
        String query = generateQueryForgetHospitalCallout(queryName, queryCity, queryCountry);

        Http http = new Http();
        HttpRequest request = getRequest('GET', query, '');
        HttpResponse response = http.send(request);
        List<Hosp_HospitalWrapperForRest> hospitalList = (List<Hosp_HospitalWrapperForRest>) JSON.deserializeStrict(response.getBody(), List<Hosp_HospitalWrapperForRest>.class);

        return hospitalList;
    }

    private String generateQueryForgetHospitalCallout(String queryName, String queryCity, String queryCountry) {
        String query = '?';
        if (String.isNotBlank(queryName)) {
            query += 'Name=' + queryName + '&';
        }
        if (String.isNotBlank(queryCity)) {
            query += 'City__c=' + queryCity + '&';
        }
        if (String.isNotBlank(queryCountry)) {
            query += 'Country__c=' + queryCountry;
        }
        query = query.replaceAll(' ', '%20');

        return query;
    }

    public HttpRequest getRequest(String methodType, String urlParams, String body) {
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

    public void deleteHospital() {
        clearMessages();

        try {
            List<Hosp_HospitalWrapperForRest> deletedHospitals = deleteHospitalCallout(hospitalToEditId);
            isAnyProblemWithDelete = false;
            Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Hospital_successfully_deleted;
            if (!Test.isRunningTest()) {
                searchHospitals();
            }
        } catch (Exception e) {
            isAnyProblemWithDelete = true;
            Hosp_ErrorToastController.messageErrorToast = Label.Hosp_Unable_to_delete_hospital;
        }
    }

    public List<Hosp_HospitalWrapperForRest> deleteHospitalCallout(String hospitalToDeleteId) {
        Http http = new Http();
        HttpRequest request = getRequest('DELETE', hospitalToDeleteId, '');
        HttpResponse response = http.send(request);
        List<Hosp_HospitalWrapperForRest> hospitalList = (List<Hosp_HospitalWrapperForRest>) JSON.deserializeStrict(response.getBody(), List<Hosp_HospitalWrapperForRest>.class);

        return hospitalList;
    }

    public void insertHospital() {
        clearMessages();

        try {
            List<Hosp_HospitalWrapperForRest> insertedHospitals = insertHospitalCallout(hospitalToInsert);
            isAnyInsertProblem = false;
            Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Hospital_successfully_added;
            refreshResultsList(insertedHospitals);
        } catch (Exception e) {
            isAnyInsertProblem = true;
            Hosp_ErrorToastController.messageErrorToast = Label.Hosp_Unable_to_add_hospital;
            System.debug('isAnyInsertProblem=' + e);
        }
    }

    public List<Hosp_HospitalWrapperForRest> insertHospitalCallout(Hospital__c hospital) {
        String body = JSON.serialize(new Hosp_HospitalWrapperForRest(hospital), true);
        body = '{ "hospitals"  : [ ' + body + ' ] }';

        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', body);

        HttpResponse response = http.send(request);
        List<Hosp_HospitalWrapperForRest> hospitalList = (List<Hosp_HospitalWrapperForRest>) JSON.deserializeStrict(response.getBody(), List<Hosp_HospitalWrapperForRest>.class);

        System.debug(response.getStatus());

        return hospitalList;
    }

    public void resetHospitalToInsert() {
        clearMessages();
        isAnyInsertProblem = true;
        hospitalToInsert = new Hospital__c();
    }

    public void openHospitalToEdit() {
        resetHospitalToUpdate();

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

    public void updateHospital() {
        clearMessages();

        try {
            List<Hosp_HospitalWrapperForRest> updatedHospitals = insertHospitalCallout(hospitalToEdit);

            isAnyUpdateProblem = false;
            Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Hospital_successfully_updated;
            refreshResultsList(updatedHospitals);
        } catch (Exception e) {
            isAnyUpdateProblem = true;
            Hosp_ErrorToastController.messageErrorToast = Label.Hosp_Unable_to_update_hospital;
            System.debug('isAnyUpdateProblem=' + e.getMessage());
        }
    }

    public void resetHospitalToUpdate() {
        clearMessages();
        isAnyUpdateProblem = true;
        hospitalToEdit = new Hospital__c();
    }

    private void refreshResultsList(List<Hosp_HospitalWrapperForRest> hospitals) {
        if (!hospitals.isEmpty()
                && (String.isNotBlank(hospitalToSearch.Name)
                || String.isNotBlank(hospitalToSearch.City__c)
                || String.isNotBlank(hospitalToSearch.Country__c))) {
            hospitalToEditId = hospitals.get(0).hospitalId;

            if (!Test.isRunningTest()) {
                searchHospitals();
            }
        }
    }

    public void clearMessages() {
        ApexPages.getMessages().clear();
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

