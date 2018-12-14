public class Hosp_Utils {

    public static User__c getCurrentUser() {
        return getUser(UserInfo.getUserId());
    }

    public static User__c getUser(String userId) {
        List<User__c> userItem = [SELECT Id, Email__c, Country__c FROM User__c WHERE Id = :userId];
        if(userItem.isEmpty()) {
            return null;
        } else {
            return userItem[0];
        }
    }

    public static void sendEmailToDoctor(List<Doctor__c> doctors) {
        List<String> emails = new List<String>();
        for(Doctor__c doctor : doctors) {
            String e = doctor.Email__c;
            if (e != null) {
                emails.add(e);
            }
        }

        if(!emails.isEmpty()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emails);
            mail.setSenderDisplayName(System.Label.Mail_to_Doctor_Sender_Name);
            mail.setSubject(System.Label.Mail_to_Doctor_Subject);
            mail.setPlainTextBody(System.Label.Mail_to_Doctor_Body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                    mail
            });
        }
    }

    public static String doctorQueryBuilder(Doctor__c doctor, String sortOrder, String sortAscDesc) {
        String queryDoctor = 'SELECT Id FROM Doctor__c LIMIT 0';
        if(String.isNotBlank(doctor.Name)) {
            queryDoctor = 'SELECT Id, Name, FirstName__c, Email__c, Country__c, FirstLastName__c FROM Doctor__c WHERE Name LIKE \'' + doctor.Name + '%\''
                    + addToWhereIfNotBlank(doctor.FirstName__c) + addToWhereIfNotBlank(doctor.Email__c) + addToWhereIfNotBlank(doctor.Country__c)
                    + ' ORDER BY ' + sortOrder + ' ' + sortAscDesc;
        }

        return queryDoctor;
    }

    private static String addToWhereIfNotBlank(String checkedField) {
        if (String.isNotBlank(checkedField)) {
            return ' AND FirstName__c LIKE \'' + checkedField + '%\'';
        } else {
            return '';
        }
    }

}