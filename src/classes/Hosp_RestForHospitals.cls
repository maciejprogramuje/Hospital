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
        List<Hospital__c> hospitalsToInsert = new List<Hospital__c>();

        List<String> externalIds = new List<String>();
        for (Hosp_HospitalWrapperForRest hospital : hospitals) {
            if(String.isBlank(hospital.externalId)) {
                hospital.externalId = hospital.name + hospital.city + hospital.country + hospital.street;
            }
            externalIds.add(hospital.externalId);
        }

        List<Hospital__c> listToCompare = [SELECT Id,
                ExternalId__c,
                Name,
                City__c,
                Country__c,
                WWW__c,
                Street__c,
                PostalCode__c
            FROM Hospital__c
            WHERE ExternalId__c IN :externalIds];

        for (Hospital__c hospital : listToCompare) {
            for (Hosp_HospitalWrapperForRest hosp : hospitals) {
                if (String.valueOf(hospital.ExternalId__c).equals(hosp.externalId)) {
                    hospital.Name = hosp.name;
                    hospital.Country__c = hosp.country;
                    hospital.City__c = hosp.city;
                    hospital.PostalCode__c = hosp.postalCode;
                    hospital.Street__c = hosp.street;
                }
            }
        }

        if (!listToCompare.isEmpty()) {
            update listToCompare;
        }

        if (listToCompare.isEmpty()) {
            for (Hosp_HospitalWrapperForRest hosp : hospitals) {
                hospitalsToInsert.add(new Hospital__c(
                        ExternalId__c = hosp.externalId,
                        Name = hosp.name,
                        Country__c = hosp.country,
                        City__c = hosp.city,
                        PostalCode__c = hosp.postalCode,
                        Street__c = hosp.street));
            }
        } else {
            for (Hosp_HospitalWrapperForRest hosp : hospitals) {
                for (Hospital__c hospital : listToCompare) {
                    if (!String.valueOf(hospital.ExternalId__c).equals(hosp.externalId)) {
                        hospitalsToInsert.add(new Hospital__c(
                                ExternalId__c = hosp.externalId,
                                Name = hosp.name,
                                Country__c = hosp.country,
                                City__c = hosp.city,
                                PostalCode__c = hosp.postalCode,
                                Street__c = hosp.street));
                    }
                }
            }
        }

        if (!hospitalsToInsert.isEmpty()) {
            upsert hospitalsToInsert;
        }

        hospitalsToInsert.addAll(listToCompare);

        List<Hosp_HospitalWrapperForRest> resultsHospitals = new List<Hosp_HospitalWrapperForRest>();
        for (Hospital__c rawHospital : hospitalsToInsert) {
            resultsHospitals.add(new Hosp_HospitalWrapperForRest(rawHospital));
        }
        return resultsHospitals;
    }

    @HttpDelete
    global static List<Hosp_HospitalWrapperForRest> deleteHospitals() {
        RestRequest request = RestContext.request;
        String hospitalIds = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);

        List<String> ids = hospitalIds.split(',');

        List<Hospital__c> listToDel = [
                SELECT Id,
                        ExternalId__c,
                        Name,
                        Country__c,
                        City__c,
                        PostalCode__c,
                        Street__c
                FROM Hospital__c
                WHERE ExternalId__c IN :ids
        ];

        delete listToDel;

        List<Hosp_HospitalWrapperForRest> hospitals = new List<Hosp_HospitalWrapperForRest>();
        for (Hospital__c rawHospital : listToDel) {
            hospitals.add(new Hosp_HospitalWrapperForRest(rawHospital));
        }

        return hospitals;
    }

    private static String generateQuery(Map<String, String> pairsNameValue) {
        String query = 'SELECT Id, ExternalId__c, Name, Country__c, City__c, PostalCode__c, Street__c FROM Hospital__c';
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