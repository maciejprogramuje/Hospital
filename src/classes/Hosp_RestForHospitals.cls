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
        List<Hospital__c> hospitalListToUpdate = new List<Hospital__c>();
        List<Hospital__c> hospitalListToInsert = new List<Hospital__c>();
        Set<Hospital__c> hospitalSetToInsert = new Set<Hospital__c>();
        List<Hospital__c> hospitalListToDelete = new List<Hospital__c>();

        List<String> externalIds = new List<String>();
        for (Hosp_HospitalWrapperForRest hospital : hospitals) {
            externalIds.add(hospital.externalId);
        }

        List<Hospital__c> listToCompare = [SELECT Id, ExternalId__c, Name, City__c, Country__c, WWW__c, Street__c, PostalCode__c FROM Hospital__c WHERE ExternalId__c IN:externalIds];
        for (Hospital__c hospital : listToCompare) {
            for (Hosp_HospitalWrapperForRest hospitalExternal : hospitals) {
                if (String.valueOf(hospital.ExternalId__c).equals(hospitalExternal.externalId)) {
                    hospital.Name = hospitalExternal.name;
                    hospital.Country__c = hospitalExternal.country;
                    hospital.City__c = hospitalExternal.city;
                    hospital.PostalCode__c = hospitalExternal.postalCode;
                    hospital.Street__c = hospitalExternal.street;
                }
            }
        }

        if (listToCompare.size() > 0) {
            update listToCompare;
        }

        if (listToCompare.size() == 0) {
            for (Hosp_HospitalWrapperForRest hospitalFrom : hospitals) {
                hospitalListToInsert.add(new Hospital__c(
                        ExternalId__c = hospitalFrom.externalId,
                        Name = hospitalFrom.name,
                        Country__c = hospitalFrom.country,
                        City__c = hospitalFrom.city,
                        PostalCode__c = hospitalFrom.postalCode,
                        Street__c = hospitalFrom.street));
            }
        } else {
            for (Hosp_HospitalWrapperForRest hospitalFrom : hospitals) {
                for (Hospital__c hospital : listToCompare) {
                    if (!String.valueOf(hospital.ExternalId__c).equals(hospitalFrom.externalId)) {
                        hospitalListToInsert.add(new Hospital__c(
                                ExternalId__c = hospitalFrom.externalId,
                                Name = hospitalFrom.name,
                                Country__c = hospitalFrom.country,
                                City__c = hospitalFrom.city,
                                PostalCode__c = hospitalFrom.postalCode,
                                Street__c = hospitalFrom.street));
                    }
                }
            }
        }

        if (hospitalListToInsert.size() > 0) {
            upsert hospitalListToInsert;
        }

        hospitalListToInsert.addAll(listToCompare);

        List<Hosp_HospitalWrapperForRest> resultsHospitals = new List<Hosp_HospitalWrapperForRest>();
        for (Hospital__c rawHospital : hospitalListToInsert) {
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