public class Hosp_Utils {

    public static String generateGuid() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);

        return guid;
    }

    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];

        for(Integer i = 0; i < bytesCount; ++i) {
            bytes[i] =  hex.mid(i << 1, 2);
        }

        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
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

    public static String generateQuerySearchForDoctorsInHospitalViewModal(Doctor__c doctor) {
        String query = 'SELECT Id, Name, FirstName__c, FirstLastName__c, Country__c, City__c, Email__c FROM Doctor__c WHERE Name LIKE \'' + doctor.Name + '%\''
                + addToWhereIfNotBlank('FirstName__c', doctor.FirstName__c)
                + addToWhereIfNotBlank('Email__c', doctor.Email__c)
                + addToWhereIfNotBlank('Country__c', doctor.Country__c)
                + ' ORDER BY Name';

        return query;
    }
}