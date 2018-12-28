global with sharing class Hosp_SoapForDoctorsWebService {

    webService static List<Doctor__c> getDoctors(String lastName, String firstName, String city, String country) {
        String query = Hosp_Utils.generateQueryGetDoctorsForSoapGetDoctors(lastName, firstName, city, country);
        if (String.isNotBlank(query)) {
            return Database.query(query);
        } else {
            return new List<Doctor__c>();
        }
    }

    webService static Doctor__c upsertDoctor(String doctorId, String lastName, String firstName, String city, String country) {
        if (String.isNotBlank(doctorId)) {
            List<Doctor__c> doctors = [SELECT Id, Name, FirstName__c, City__c, Country__c FROM Doctor__c WHERE Id = :doctorId];

            if (!doctors.isEmpty()) {
                if (String.isNotBlank(lastName)) {
                    doctors.get(0).Name = lastName;
                }
                if (String.isNotBlank(firstName)) {
                    doctors.get(0).FirstName__c = firstName;
                }
                if (String.isNotBlank(city)) {
                    doctors.get(0).City__c = city;
                }
                if (String.isNotBlank(country)) {
                    doctors.get(0).Country__c = country;
                }

                update doctors.get(0);
                return doctors.get(0);
            }
            return null;
        } else {
            return insertDoctor(lastName, firstName, city, country);
        }
    }

    private static Doctor__c insertDoctor(String lastName, String firstName, String city, String country) {
        Doctor__c doc = createDoctor(lastName, firstName, city, country);
        if(doc != null) {
            insert doc;
            return doc;
        } else {
            return null;
        }
    }

    private static Doctor__c createDoctor(String lastName, String firstName, String city, String country) {
        if (String.isNotBlank(lastName)) {
            Doctor__c doctor = new Doctor__c(Name = lastName);

            if (String.isNotBlank(firstName)) {
                doctor.FirstName__c = firstName;
            }
            if (String.isNotBlank(city)) {
                doctor.City__c = city;
            }
            if (String.isNotBlank(country)) {
                doctor.Country__c = country;
            }

            return doctor;
        } else {
            return null;
        }
    }

    webService static List<Doctor__c> deleteDoctors(List<String> doctorsIds) {
        List<Doctor__c> doctorsToDelete = [SELECT Id FROM Doctor__c WHERE Id IN :doctorsIds];

        if (!doctorsToDelete.isEmpty()) {
            delete  doctorsToDelete;
            return doctorsToDelete;
        }

        return null;
    }
}