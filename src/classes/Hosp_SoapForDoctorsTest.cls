@isTest
private class Hosp_SoapForDoctorsTest {

    @testSetup
    static void setup() {
        List<Doctor__c> testDoctors = new List<Doctor__c>();

        for (Integer i = 1; i <= 2; i++) {
            testDoctors.add(new Doctor__c(Name = 'TestDoctorName' + i,
                    FirstName__c = 'TestDoctorFirstName' + i,
                    City__c = 'City1',
                    Country__c = 'PL'));
        }
        insert testDoctors;
    }

    @isTest
    static void shouldGetDoctors_WithAllParams() {
        //given
        String doctorsNames = 'TestDoctorName1';
        String doctorsFirstNames = 'TestDoctorFirstName1';
        String doctorsCity = 'City1';
        String doctorsCountry = 'PL';

        //when
        List<Hosp_DoctorWrapperForSoap> results = Hosp_SoapForDoctorsWebService.getDoctors(doctorsNames, doctorsFirstNames, doctorsCity, doctorsCountry);

        //then
        System.assertEquals(1, results.size());
    }

    @isTest
    static void shouldNotGetDoctors_WithNoParams() {
        //given
        String doctorsNames = '';
        String doctorsFirstNames = '';
        String doctorsCity = '';
        String doctorsCountry = '';

        //when
        List<Hosp_DoctorWrapperForSoap> results = Hosp_SoapForDoctorsWebService.getDoctors(doctorsNames, doctorsFirstNames, doctorsCity, doctorsCountry);

        //then
        System.assertEquals(0, results.size());
    }

    @isTest
    static void shouldNotGetDoctors_WithNotExistsName() {
        //given
        String doctorsNames = 'TestDoctorName3';
        String doctorsFirstNames = '';
        String doctorsCity = '';
        String doctorsCountry = '';

        //when
        List<Hosp_DoctorWrapperForSoap> results = Hosp_SoapForDoctorsWebService.getDoctors(doctorsNames, doctorsFirstNames, doctorsCity, doctorsCountry);

        //then
        System.assertEquals(0, results.size());
    }

    @isTest
    static void shouldDeleteDoctors_TrueDoctorsIds() {
        //given
        List<Doctor__c> doctors = [SELECT Id, Name, FirstName__c, Country__c, City__c FROM Doctor__c WHERE Name LIKE 'TestDoctorName%'];
        List<String> doctorsIds = new List<String>();
        for (Doctor__c d : doctors) {
            doctorsIds.add(d.Id);
        }

        //when
        List<Hosp_DoctorWrapperForSoap> results = Hosp_SoapForDoctorsWebService.deleteDoctors(doctorsIds);

        //then
        System.assertEquals(2, results.size());
    }

    @isTest
    static void shouldNotDeleteDoctors_FakeDoctorsIds() {
        //given
        List<Doctor__c> doctors = [SELECT Id, Name, FirstName__c, Country__c, City__c FROM Doctor__c WHERE Name LIKE 'TestDoctorName3'];
        List<String> doctorsIds = new List<String>();
        for (Doctor__c d : doctors) {
            doctorsIds.add(d.Id);
        }

        //when
        List<Hosp_DoctorWrapperForSoap> results = Hosp_SoapForDoctorsWebService.deleteDoctors(doctorsIds);

        //then
        System.assertEquals(0, results.size());
    }

    @isTest
    static void shouldUpsertDoctor_UpsertTrueDoctor() {
        //given
        List<Doctor__c> doctors = [SELECT Id, Name, FirstName__c, Country__c, City__c FROM Doctor__c WHERE Name LIKE 'TestDoctorName1'];

        String lastNameAfterChange = 'TestDoctorName3';
        String firstNameAfterChange = 'TestDoctorFirstName3';

        //when
        Hosp_DoctorWrapperForSoap result;
        if(!doctors.isEmpty()) {
            result = Hosp_SoapForDoctorsWebService.upsertDoctor(doctors.get(0).Id, lastNameAfterChange, firstNameAfterChange, doctors.get(0).City__c, doctors.get(0).Country__c);
        }

        //then
        System.assertEquals(lastNameAfterChange, result.Name);
    }

    @isTest
    static void shouldNotUpsertDoctor_UpsertFakeDoctor() {
        //given
        List<Doctor__c> doctors = [SELECT Id, Name, FirstName__c, Country__c, City__c FROM Doctor__c WHERE Name LIKE 'TestDoctorName4'];

        String lastNameAfterChange = 'TestDoctorName3';
        String firstNameAfterChange = 'TestDoctorFirstName3';

        //when
        Hosp_DoctorWrapperForSoap result;
        if(!doctors.isEmpty()) {
            result = Hosp_SoapForDoctorsWebService.upsertDoctor(doctors.get(0).Id, lastNameAfterChange, firstNameAfterChange, doctors.get(0).City__c, doctors.get(0).Country__c);
        }

        //then
        System.assertEquals(0, doctors.size());
    }

    @isTest
    static void shouldUpsertDoctor_Insert() {
        //given
        String lastName = 'TestDoctorName4';
        String firstName = 'TestDoctorFirstName4';
        String city = 'City4';
        String country = 'PL';

        //when
        Hosp_DoctorWrapperForSoap result;
        if(String.isNotBlank(lastName) && String.isNotBlank(firstName)) {
            result = Hosp_SoapForDoctorsWebService.upsertDoctor('', lastName, firstName, city, country);
        }

        //then
        System.assertNotEquals(null, result.doctorId);
    }

    @isTest
    static void shouldNotUpsertDoctor_InsertWithoutRequiredFields() {
        //given
        String lastName;
        String firstName;
        String city = 'City4';
        String country = 'PL';

        //when
        Hosp_DoctorWrapperForSoap result;
        if(String.isNotBlank(lastName) && String.isNotBlank(firstName)) {
            result = Hosp_SoapForDoctorsWebService.upsertDoctor('', lastName, firstName, city, country);
        }

        //then
        System.assertEquals(null, result);
    }
}