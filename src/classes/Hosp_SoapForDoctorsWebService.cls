global with sharing class Hosp_SoapForDoctorsWebService {

    webService static List<Hosp_DoctorWrapperForSoap> getDoctors(String lastName, String firstName, String city, String country) {
        String query = Hosp_Utils.generateQueryGetDoctorsForSoapGetDoctors(lastName, firstName, city, country);

        List<Hosp_DoctorWrapperForSoap> resultsDoctors = new List<Hosp_DoctorWrapperForSoap>();
        if (String.isNotBlank(query)) {
            List<Doctor__c> rawDoctors = Database.query(query);
            for (Doctor__c rawDoctor : rawDoctors) {
                resultsDoctors.add(new Hosp_DoctorWrapperForSoap(rawDoctor));
            }
        }

        return resultsDoctors;
    }

    webService static Hosp_DoctorWrapperForSoap upsertDoctor(String doctorId, String lastName, String firstName, String city, String country) {
        Doctor__c rawDoctor = new Doctor__c();
        if (String.isNotBlank(doctorId)) {
            rawDoctor.Id = doctorId;
        }
        if (String.isNotBlank(lastName)) {
            rawDoctor.Name = lastName;
        }
        if (String.isNotBlank(firstName)) {
            rawDoctor.FirstName__c = firstName;
        }
        if (String.isNotBlank(city)) {
            rawDoctor.City__c = city;
        }
        if (String.isNotBlank(country)) {
            rawDoctor.Country__c = country;
        }

        upsert rawDoctor;

        return new Hosp_DoctorWrapperForSoap(rawDoctor);
    }

    webService static List<Hosp_DoctorWrapperForSoap> deleteDoctors(List<String> doctorsIds) {
        List<Doctor__c> doctorsToDelete = [SELECT Id, Name, FirstName__c, Country__c, City__c FROM Doctor__c WHERE Id IN :doctorsIds];

        List<Hosp_DoctorWrapperForSoap> resultsDoctors = new List<Hosp_DoctorWrapperForSoap>();

        if (!doctorsToDelete.isEmpty()) {
            delete doctorsToDelete;

            for (Doctor__c rawDoctor : doctorsToDelete) {
                resultsDoctors.add(new Hosp_DoctorWrapperForSoap(rawDoctor));
            }
        }

        return resultsDoctors;
    }

}