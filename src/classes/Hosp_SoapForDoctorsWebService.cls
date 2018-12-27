global with sharing class Hosp_SoapForDoctorsWebService {

    webService static List<Doctor__c> getDoctors(String lastName, String firstName, String city, String country) {
        String query = Hosp_Utils.generateQueryGetDoctorsForSoapGetDoctors(lastName, firstName, city, country);
        if(String.isNotBlank(query)) {
            return Database.query(query);
        } else {
            return new List<Doctor__c>();
        }
    }

    webService static String updateDoctor(String doctorId, String lastName, String firstName, String city, String country) {
        List<Doctor__c> doctors = [SELECT Id, Name, FirstName__c, City__c, Country__c FROM Doctor__c WHERE Id = :doctorId];
        if (!doctors.isEmpty()) {
            Doctor__c doctor = doctors.get(0);

            if (String.isNotBlank(lastName)) {
                doctor.Name = lastName;
            }
            if (String.isNotBlank(firstName)) {
                doctor.FirstName__c = firstName;
            }
            if (String.isNotBlank(city)) {
                doctor.City__c = city;
            }
            if (String.isNotBlank(country)) {
                doctor.Country__c = country;
            }

            try {
                update doctor;
                return String.format(Label.Hosp_SoapSuccessUpdated, new List<String>{
                        doctorId
                });
            } catch (Exception e) {
                System.debug(e);
                return String.format(Label.Hosp_SoapFailedProblemId, new List<String>{
                        doctorId
                });
            }
        } else {
            return String.format(Label.Hosp_SoapFialedWrongId, new List<String>{
                    doctorId
            });
        }
    }

    webService static List<String> deleteDoctors(List<String> doctorsIds) {
        List<Doctor__c> doctorsToDelete = [SELECT Id FROM Doctor__c WHERE Id IN :doctorsIds];

        List<Database.DeleteResult> deleteResults = Database.delete(doctorsToDelete, false);

        List<String> results = new List<String>();
        for (Integer i = 0; i < deleteResults.size(); i++) {
            if (deleteResults.get(i).isSuccess()) {
                results.add(String.format(Label.Hosp_SoapRecordDeleted, new List<String >{
                        doctorsIds.get(i)
                }));
            } else {
                results.add(String.format(Label.Hosp_SoapRecordNotDeleted, new List<String>{
                        doctorsIds.get(i), deleteResults.get(i).errors[0].getMessage()
                }));
            }
        }

        if (results.isEmpty()) {
            results.add(Label.Hosp_SoapNoRecordsToDelete);
        }

        return results;
    }
}