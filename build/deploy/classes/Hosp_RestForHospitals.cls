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
        List<String> externalIds = new List<String>();
        for (Hosp_HospitalWrapperForRest hosp : hospitals) {
            externalIds.add(hosp.externalId);
        }

        List<Hospital__c> hospitalsAt2OrgAnd1Org = [SELECT Id, ExternalId__c FROM Hospital__c WHERE ExternalID__c IN :externalIds];

        List<Hospital__c> hospitalsToUpdate = new List<Hospital__c>();

        for (Hosp_HospitalWrapperForRest incomingHospital : hospitals) {
            for (Hospital__c hospitalAt2OrgAnd1Org : hospitalsAt2OrgAnd1Org) {
                if (hospitalAt2OrgAnd1Org.ExternalId__c == incomingHospital.externalId) {
                    hospitalAt2OrgAnd1Org.Name = incomingHospital.name;
                    hospitalAt2OrgAnd1Org.Street__c = incomingHospital.street;
                    hospitalAt2OrgAnd1Org.City__c = incomingHospital.city;
                    hospitalAt2OrgAnd1Org.Country__c = incomingHospital.country;
                    hospitalAt2OrgAnd1Org.PostalCode__c = incomingHospital.postalCode;

                    hospitalsToUpdate.add(hospitalAt2OrgAnd1Org);
                }
            }
        }

        if (!hospitalsToUpdate.isEmpty()) {
            update hospitalsToUpdate;
        }

        List<Hospital__c> hospitalsToInsert = new List<Hospital__c>();

        for (Hosp_HospitalWrapperForRest incomingHospital : hospitals) {
            if (!hospitalsToUpdate.isEmpty()) {
                for (Hospital__c hospitalToUpdate : hospitalsToUpdate) {
                    if (incomingHospital.externalId != hospitalToUpdate.ExternalId__c) {
                        hospitalsToInsert.add(new Hospital__c(
                                ExternalId__c = incomingHospital.externalId,
                                Name = incomingHospital.name,
                                City__c = incomingHospital.city,
                                Country__c = incomingHospital.country,
                                Street__c = incomingHospital.street,
                                PostalCode__c = incomingHospital.postalCode
                        ));
                    }
                }
            } else {
                hospitalsToInsert.add(new Hospital__c(
                        ExternalId__c = incomingHospital.externalId,
                        Name = incomingHospital.name,
                        City__c = incomingHospital.city,
                        Country__c = incomingHospital.country,
                        Street__c = incomingHospital.street,
                        PostalCode__c = incomingHospital.postalCode
                ));
            }
        }

        if (!hospitalsToInsert.isEmpty()) {
            insert hospitalsToInsert;
        }

        List<Hospital__c> hospitalsList = new List<Hospital__c>();
        hospitalsList.addAll(hospitalsToUpdate);
        hospitalsList.addAll(hospitalsToInsert);
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