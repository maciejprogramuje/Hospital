@RestResource(urlMapping='/Hospital__c/*')
global with sharing class Hosp_RestForHospitals {

    @HttpGet
    global static List<Hosp_HospitalWrapperForRest> getHospitals() {
        Map<String, String> requestParams = RestContext.request.params;

        String query = generateQuery(requestParams);
        if (query == null) {
            return new List<Hosp_HospitalWrapperForRest>();
        }
        List<Hospital__c> rawHospitals = Database.query(query);

        List<Hosp_HospitalWrapperForRest> hospitals = new List<Hosp_HospitalWrapperForRest>();
        for (Hospital__c rawHospital : rawHospitals) {
            hospitals.add(new Hosp_HospitalWrapperForRest(rawHospital));
        }

        return hospitals;
    }

    @HttpPut
    global static List<Hosp_HospitalWrapperForRest> upsertHospitals(List<Hosp_HospitalWrapperForRest> hospitals) {
        List<Hospital__c> hospitalsList = new List<Hospital__c>();
        for (Hosp_HospitalWrapperForRest hosp : hospitals) {
            hospitalsList.add(new Hospital__c(ExternalId__c = hosp.hospitalId,
                    Name = hosp.name,
                    Country__c = hosp.country,
                    City__c = hosp.city,
                    PostalCode__c = hosp.postalCode,
                    Street__c = hosp.street));
        }

        System.debug('hospitalsList to insert >>' + hospitalsList);

        upsert hospitalsList;


        List<Hosp_HospitalWrapperForRest> resultsHospitals = new List<Hosp_HospitalWrapperForRest>();
        for (Hospital__c rawHospital : hospitalsList) {
            resultsHospitals.add(new Hosp_HospitalWrapperForRest(rawHospital));
        }

        return resultsHospitals;
    }

    @HttpDelete
    global static List<Hosp_HospitalWrapperForRest> deleteHospitals() {
        RestRequest request = RestContext.request;
        String hospitalIds = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);


        System.debug('hospitalIds=' + hospitalIds);

        List<String> ids = hospitalIds.split(',');

        List<Hospital__c> listToDel = [
                SELECT Id,
                        Name,
                        Country__c,
                        City__c,
                        PostalCode__c,
                        Street__c
                FROM Hospital__c
                WHERE Id IN :ids
        ];

        System.debug('listToDel=' + listToDel);

        delete listToDel;

        List<Hosp_HospitalWrapperForRest> hospitals = new List<Hosp_HospitalWrapperForRest>();
        for (Hospital__c rawHospital : listToDel) {
            hospitals.add(new Hosp_HospitalWrapperForRest(rawHospital));
        }

        return hospitals;
    }

    private static String generateQuery(Map<String, String> pairsNameValue) {
        String query = 'SELECT Id, Name, Country__c, City__c, PostalCode__c, Street__c FROM Hospital__c';
        try {
            Set<String> fields = pairsNameValue.keySet();
            if (!fields.isEmpty()) {
                Integer i = 0;
                Map<String, Schema.SObjectField> fieldsWithTypes = Schema.SObjectType.Hospital__c.fields.getMap();
                String fieldType;
                for (String field : fields) {
                    fieldType = fieldsWithTypes.get(field).getDescribe().getType().name();
                    if (i != 0) {
                        query += ' AND ';
                    } else {
                        query += ' WHERE ';
                    }
                    if (fieldType != 'INTEGER' && fieldType != 'DOUBLE' && fieldType != 'CURRENCY' && fieldType != 'DATE' && fieldType != 'BOOLEAN') {
                        query += field + ' LIKE \'' + pairsNameValue.get(field) + '%\'';
                    } else {
                        query += field + ' = ' + pairsNameValue.get(field);
                    }
                    i++;
                }
            }
        } catch (Exception ex) {
            System.debug(ex);
            return null;
        }
        return query;
    }
}