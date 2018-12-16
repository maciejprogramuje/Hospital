public class Hosp_Utils {

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
        return 'SELECT Id, Name, FirstName__c, Email__c, Country__c, FirstLastName__c FROM Doctor__c WHERE Name LIKE \'' + doctor.Name + '%\''
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

}