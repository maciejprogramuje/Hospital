public with sharing class Hosp_DoctorJsonHandler {
    public static String getDoctorsInJson(List<Doctor__c> doctorsToExport) {
        JSONGenerator generator = JSON.createGenerator(true);

        generator.writeStartArray();

        for(Doctor__c doc : doctorsToExport) {
            generator.writeStartObject();

            generator.writeStringField(Schema.Doctor__c.fields.FirstLastName__c.getDescribe().getLabel(), notBlankField(doc.FirstLastName__c));
            generator.writeStringField(Schema.Doctor__c.fields.Email__c.getDescribe().getLabel(), notBlankField(doc.Email__c));
            generator.writeStringField(Schema.Doctor__c.fields.Country__c.getDescribe().getLabel(), notBlankField(doc.Country__c));

            generator.writeEndObject();
        }

        generator.writeEndArray();

        return generator.getAsString();
    }

    private static String notBlankField(String field) {
        if(String.isNotBlank(field)) {
            return field;
        } else {
            return '';
        }
    }
}