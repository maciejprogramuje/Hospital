public class Hosp_Utils {
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

    public static User__c getCurrentUser() {
        return getUser(UserInfo.getUserId());
    }

    public static User__c getUser(String userId) {
        List<User__c> userItem = [SELECT Id, Email__c, Country__c FROM User__c WHERE Id = :userId];
        if (userItem.isEmpty()) {
            return null;
        } else {
            return userItem[0];
        }
    }

    public static void sendEmailToDoctor(List<Doctor__c> doctors) {
        List<String> emails = new List<String>();
        for (Doctor__c doctor : doctors) {
            String e = doctor.Email__c;
            if (e != null) {
                emails.add(e);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emails);
            mail.setSenderDisplayName(System.Label.Mail_to_Doctor_Sender_Name);
            mail.setSubject(System.Label.Mail_to_Doctor_Subject);
            mail.setPlainTextBody(System.Label.Mail_to_Doctor_Body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                    mail
            });
        }
    }

    public static String doctorQueryBuilder(Doctor__c doctor, String sortOrder, String sortAscDesc) {
        return 'SELECT Id, Name, FirstName__c, Email__c, City__c, Country__c, FirstLastName__c FROM Doctor__c WHERE Name LIKE \'' + doctor.Name + '%\''
                + addToWhereIfNotBlank('FirstName__c', doctor.FirstName__c)
                + addToWhereIfNotBlank('Email__c', doctor.Email__c)
                + addToWhereIfNotBlank('Country__c', doctor.Country__c)
                + ' ORDER BY ' + sortOrder + ' ' + sortAscDesc;
    }

    private static String addToWhereIfNotBlank(String fieldName, String checkedField) {
        if (String.isNotBlank(checkedField)) {
            return ' AND ' + fieldName + ' LIKE \'' + checkedField + '%\'';
        } else {
            return ' ';
        }
    }

    public static String generateHireDoctorHospitalsQuery(Hospital__c hospital) {
        String query = '';

        if(String.isNotBlank(hospital.Name)) {
            query = 'SELECT Id, Name, Country__c, City__c, WWW__c FROM Hospital__c WHERE Name LIKE \'' + hospital.Name + '%\''
                    + addToWhereIfNotBlank('WWW__c', hospital.WWW__c)
                    + addToWhereIfNotBlank('Country__c', hospital.Country__c);
        } else if(String.isNotBlank(hospital.WWW__c)) {
            query = 'SELECT Id, Name, Country__c, City__c, WWW__c FROM Hospital__c WHERE WWW__c LIKE \'' + hospital.WWW__c + '%\''
                    + addToWhereIfNotBlank('Country__c', hospital.Country__c);
        } else if(String.isNotBlank(hospital.Country__c)) {
            query = 'SELECT Id, Name, Country__c, City__c, WWW__c FROM Hospital__c WHERE Country__c = \'' + hospital.Country__c + '\'';
        }

        return query;
    }
}