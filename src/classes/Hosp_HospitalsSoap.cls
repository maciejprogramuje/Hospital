global class Hosp_HospitalsSoap {
    webService static Hosp_HospitalWrapperForRest upsertHospital(String hospitalId, String name, String country, String city,
            String postalCode, String street) {
        Hospital__c hospital = new Hospital__c();
        if (String.isNotBlank(hospitalId)) {
            hospital = new Hospital__c(Id = hospitalId);
        }
        if (String.isNotBlank(name)) {
            hospital.Name = name;
        }
        if (String.isNotBlank(country)) {
            hospital.Country__c = country;
        }
        if (String.isNotBlank(city)) {
            hospital.City__c = city;
        }
        if (String.isNotBlank(postalCode)) {
            hospital.PostalCode__c = postalCode;
        }
        if (String.isNotBlank(street)) {
            hospital.Street__c = street;
        }
        if (String.isNotBlank(street)) {
            hospital.Street__c = street;
        }
        upsert hospital;
        return new Hosp_HospitalWrapperForRest(hospital);
    }

    webService static List<Hosp_HospitalWrapperForRest> getHospitals(String hospitalId, String name, String country, String city,
            String postalCode, String street) {
        String query = 'SELECT Id, Name, Country__c, City__c, PostalCode__c, Street__c, ExternalId__c FROM Hospital__c';
        List<Hospital__c> hospitals = Database.query(query);
        List<Hosp_HospitalWrapperForRest> hospitalsWrapperForSOAP = new List<Hosp_HospitalWrapperForRest>();

        for (Hospital__c hospital : hospitals) {
            hospitalsWrapperForSOAP.add(new Hosp_HospitalWrapperForRest(hospital));
        }
        return hospitalsWrapperForSOAP;
    }
}