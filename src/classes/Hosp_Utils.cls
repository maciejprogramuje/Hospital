public class Hosp_Utils {

    public static String generateGuid() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0, 8) + '-' + h.SubString(8, 12) + '-' + h.SubString(12, 16) + '-' + h.SubString(16, 20) + '-' + h.substring(20);

        return guid;
    }


    public static String blobToString(Blob input, String inCharset) {
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];

        for (Integer i = 0; i < bytesCount; ++i) {
            bytes[i] = hex.mid(i << 1, 2);
        }

        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
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

    public static String generateHireDoctorHospitalsQuery(Hospital__c hospital) {
        String query = '';

        if (String.isNotBlank(hospital.Name)) {
            query = 'SELECT Id, Name, Country__c, City__c, WWW__c FROM Hospital__c WHERE Name LIKE \'' + hospital.Name + '%\''
                    + addToWhereIfNotBlank('WWW__c', hospital.WWW__c)
                    + addToWhereIfNotBlank('Country__c', hospital.Country__c);
        } else if (String.isNotBlank(hospital.WWW__c)) {
            query = 'SELECT Id, Name, Country__c, City__c, WWW__c FROM Hospital__c WHERE WWW__c LIKE \'' + hospital.WWW__c + '%\''
                    + addToWhereIfNotBlank('Country__c', hospital.Country__c);
        } else if (String.isNotBlank(hospital.Country__c)) {
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

    public static String generateQueryForCheckIsDoctorExistInDoctorEdit(Doctor__c doctor) {
        String doctorQuery = 'SELECT Id, Name FROM Doctor__c WHERE Name = \'' + doctor.Name + '\'';
        if (String.isNotBlank(doctor.FirstName__c)) {
            doctorQuery += ' AND FirstName__c = \'' + doctor.FirstName__c + '\'' ;
        }

        return doctorQuery;
    }

    public static String generateQueryGetDoctorsForSoapGetDoctors(String lastName, String firstName, String city, String country) {
        String query = '';

        if (String.isNotBlank(lastName)) {
            query = 'SELECT Id, Name, FirstName__c, City__c, Country__c FROM Doctor__c WHERE Name LIKE \'' + lastName + '%\''
                    + addToWhereIfNotBlank('FirstName__c', firstName)
                    + addToWhereIfNotBlank('City__c', city)
                    + addToWhereIfNotBlankAndEquals('Country__c', country);
        } else if (String.isNotBlank(firstName)) {
            query = 'SELECT Id, Name, FirstName__c, City__c, Country__c FROM Doctor__c WHERE FirstName__c LIKE \'' + firstName + '%\''
                    + addToWhereIfNotBlank('City__c', city)
                    + addToWhereIfNotBlankAndEquals('Country__c', country);
        } else if (String.isNotBlank(city)) {
            query = 'SELECT Id, Name, FirstName__c, City__c, Country__c FROM Doctor__c WHERE City__c LIKE \'' + city + '%\''
                    + addToWhereIfNotBlankAndEquals('Country__c', country);
        } else if (String.isNotBlank(country)) {
            query = 'SELECT Id, Name, FirstName__c, City__c, Country__c FROM Doctor__c WHERE Country__c = \'' + country + '\'';
        }

        return query;
    }

    private static String addToWhereIfNotBlankAndEquals(String fieldName, String checkedField) {
        if (String.isNotBlank(checkedField)) {
            return ' AND ' + fieldName + ' = \'' + checkedField + '\'';
        } else {
            return ' ';
        }
    }

    private static String addToWhereIfNotBlank(String fieldName, String checkedField) {
        if (String.isNotBlank(checkedField)) {
            return ' AND ' + fieldName + ' LIKE \'' + checkedField + '%\'';
        } else {
            return ' ';
        }
    }

    public static String getAccessToken(String username, String password, String ClientId, String ClientSecret) {
        String endpoint = 'https://login.salesforce.com/services/oauth2/token';

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        req.setBody('grant_type=password' +
                '&client_id=' + ClientId +
                '&client_secret=' + ClientSecret +
                '&username=' + username +
                '&password=' + password
        );
        req.setEndpoint(endpoint);
        Http http = new Http();
        HttpResponse res;
        String accessToken;
        try {
            res = http.send(req);
            system.debug('Hosp_Utils getAccessToken body:' + res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    accessToken = parser.getText();
                }
            }
        } catch (system.CalloutException e) {
            System.debug('error >>> ' + e);
        }

        return accessToken;
    }

    public static Boolean isFunctionalityEnabled(String csName) {
        return isFunctionalityEnabled(csName, getCurrentUser().Country);
    }

    public static Boolean isFunctionalityEnabled(String csName, String country) {
        Hosp_CustomSetting__c csItem = Hosp_CustomSetting__c.getInstance(csName);
        if (csItem == null) {
            return false;
        }

        List<String> values = csItem.Value__c.split(',');

        return values.contains(country);
    }

    public static User getCurrentUser() {
        if(Cache.Session.get('HospitalCurrentUser') == null){
            return getUser(UserInfo.getUserId());
        }

        return (User)Cache.Session.get('HospitalCurrentUser');
    }

    public static User getUser(String userId) {
        List<User> userItem = [SELECT Id, Country FROM User WHERE Id = :userId];
        if (userItem.isEmpty()) {
            return null;
        }

        Cache.Session.put('HospitalCurrentUser', userItem.get(0));

        return userItem.get(0);
    }

    public static String getInsertHospitalScheduleTime() {
        return getCsValue('InsertHospitalScheduleTime');
    }

    public static String getDeleteHospitalLogsScheduleTime() {
        return getCsValue('DeleteHospitalLogsScheduleTime');
    }


    public static String getCsValue(String csName) {
        Hosp_CustomSetting__c csItem = Hosp_CustomSetting__c.getInstance(csName);
        if (csItem == null) {
            return null;
        }

        return csItem.Value__c;
    }

    public static Integer getCsValueFromInteger(String csName) {
        return Integer.valueOf(getCsValue(csName));
    }

    public static Boolean getCsValueFromBoolean(String csName) {
        getCsValue(csName);

        return Boolean.valueOf(getCsValue(csName));
    }

    public static Boolean isTriggerEnabled(String csName) {
        Hosp_TriggerExceptions__c csItem = Hosp_TriggerExceptions__c.getInstance(UserInfo.getUserId());
        Object customSettingObject = csItem.get(csName);
        if (customSettingObject == null) {
            return false;
        }
        Boolean customSettingValue = (Boolean) customSettingObject;
        return customSettingValue;
    }

    public static void sendEmailToSystemAdmin(List<String> errorList) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        List<String> address = new List<String>();

        address.add('maciej.szymczyk@britenet.com.pl');
        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();

        String body ='Errors';

        for(String element : errorList){
            body += '\n' + element + '\n';
        }

        singleMail.setSenderDisplayName('Salesforce Hospital');
        singleMail.setSubject('Information about fail logs');
        singleMail.setTreatTargetObjectAsRecipient(false);
        singleMail.setToAddresses(address);
        singleMail.setSaveAsActivity(false);
        singleMail.setHtmlBody(body);
        emails.add(singleMail);

        Messaging.sendEmail(emails);
    }
}