@RestResource(urlMapping='/Hospital__c/*')
global with sharing class Hosp_RestForHospitals {

    @HttpGet
    global static List<Hospital__c> getHospitals() {
        Map<String, String> requestParams = RestContext.request.params;

        String query = generateQuery(requestParams);
        if (query == null) {
            return new List<Hospital__c>();
        }
        List<Hospital__c> hospitals = Database.query(query);

        return hospitals;
    }

    @HttpPut
    global static List<String> upsertHospitals(List<HospitalWrapperForRest> hospitals) {
        List<Hospital__c> hospitalsList = new List<Hospital__c>();
        for (HospitalWrapperForRest h : hospitals) {
            hospitalsList.add(new Hospital__c(Id = h.hospitalId,
                    Name = h.name,
                    Country__c = h.country,
                    City__c = h.city,
                    PostalCode__c = h.postalCode,
                    Street__c = h.street));
        }

        upsert hospitalsList;

        List<String> hId = new List<String>();
        for (Hospital__c h : hospitalsList) {
            hId.add(h.Id);
        }

        return hId;
    }

    @HttpDelete
    global static List<Hospital__c> deleteHospitals() {
        RestRequest request = RestContext.request;
        String hospitalIds = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);

        List<String> ids = hospitalIds.split(',');
        if (!ids.isEmpty()) {
            List<Hospital__c> listToDel = [SELECT Id FROM Hospital__c WHERE Id IN :ids];

            if (!listToDel.isEmpty()) {
                delete listToDel;
                return listToDel;
            }
        }
        return null;
    }

    private static String generateQuery(Map<String, String> pairsNameValue) {
        String query = 'SELECT Id, Name, Country__c, City__c FROM Hospital__c';
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