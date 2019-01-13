public with sharing class Hosp_PiotrHospitalsController {
    public Hospital__c hospitalToSearch { get; set; }
    public Hospital__c hospitalToEdit { get; set; }
    public String hospitalToEditId { get; set; }

    public Boolean isAnyProblemWithDelete { get; set; }
    public Boolean isAnyUpsertProblem { get; set; }

    public String endPoint = Label.Hosp_Endpoint_Piotr_Hospital;
    public List<Hosp_HospitalWrapperForRest> hospitalsResults { get; set; }

    public Hosp_PiotrHospitalsController() {
        hospitalsResults = new List<Hosp_HospitalWrapperForRest>();
        hospitalToSearch = new Hospital__c();
        hospitalToEdit = new Hospital__c();

        isAnyProblemWithDelete = false;
        isAnyUpsertProblem = true;
    }

    public void searchHospitals() {
        hospitalsResults = getHospitalCallout(hospitalToSearch.Name, hospitalToSearch.City__c, hospitalToSearch.Country__c);
    }

    public List<Hosp_HospitalWrapperForRest> getHospitalCallout(String queryName, String queryCity, String queryCountry) {
        String query = generateQueryForgetHospitalCallout(queryName, queryCity, queryCountry);

        Http http = new Http();
        HttpRequest request = getRequest('GET', query, '');
        HttpResponse response = http.send(request);
        List<Hosp_HospitalWrapperForRest> hospitalList = (List<Hosp_HospitalWrapperForRest>) JSON.deserialize(response.getBody(), List<Hosp_HospitalWrapperForRest>.class);

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
        request.setHeader('Authorization', 'Bearer ' + loginToPiotrGetSessionId());
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod(methodType);
        if (body != '') {
            request.setBody(body);
        }
        return request;
    }

    public String loginToPiotrGetSessionId() {
        String username = 'maciej.szymczyk@britenet.com.pl';
        String password = 'Ulka!2002sjScbwznYDOocJSdloEwSJ8l';
        String ClientId = '3MVG9fTLmJ60pJ5KOWKrx4ZK68vbm6BizsZwIiPAZvzLsVGKYalESe4NBKdrBIrRAR0IIQ3fAaJPqJ5D5srmc';
        String ClientSecret = '8058418408902575444';

        return Hosp_Utils.getAccessToken(username, password, ClientId, ClientSecret);
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
        List<Hosp_HospitalWrapperForRest> hospitalList = (List<Hosp_HospitalWrapperForRest>) JSON.deserialize(response.getBody(), List<Hosp_HospitalWrapperForRest>.class);

        return hospitalList;
    }

    public void upsertHospital() {
        clearMessages();

        try {
            List<Hosp_HospitalWrapperForRest> upsertedHospitals = upsertHospitalCallout(hospitalToEdit);
            isAnyUpsertProblem = false;
            Hosp_SuccessToastController.messageSuccessToast = Label.Hosp_Hospital_successfully_updated;
            refreshResultsList(upsertedHospitals);
        } catch (Exception e) {
            isAnyUpsertProblem = true;
            Hosp_ErrorToastController.messageErrorToast = e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            System.debug('isAnyUpsertProblem=' + e);
        }
    }

    public List<Hosp_HospitalWrapperForRest> upsertHospitalCallout(Hospital__c hospital) {
        String body = JSON.serialize(new Hosp_HospitalWrapperForRest(hospital), true);
        body = '{ "hospitals"  : [ ' + body + ' ] }';

        System.debug('body=' + body);

        Http http = new Http();
        HttpRequest request = getRequest('PUT', '', body);

        HttpResponse response = http.send(request);
        List<Hosp_HospitalWrapperForRest> hospitalList = (List<Hosp_HospitalWrapperForRest>) JSON.deserializeStrict(response.getBody(), List<Hosp_HospitalWrapperForRest>.class);

        System.debug(response.getStatus());

        return hospitalList;
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

            if (!Test.isRunningTest()) {
                searchHospitals();
            }
        }
    }

    public void clearMessages() {
        ApexPages.getMessages().clear();
    }

}

