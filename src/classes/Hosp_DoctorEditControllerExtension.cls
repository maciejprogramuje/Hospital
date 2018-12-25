public class Hosp_DoctorEditControllerExtension {
    ApexPages.StandardController standardController;

    public Hosp_DoctorEditControllerExtension(ApexPages.StandardController standardController) {
        this.standardController = standardController;
    }


    public PageReference save() {
        Doctor__c doctor = (Doctor__c) standardController.getRecord();

        List<Doctor__c> doctors = Database.query(Hosp_Utils.generateQueryForCheckIsDoctorExistInDoctorEdit(doctor));

        if (doctors.isEmpty()) {
            doctor = new Doctor__c(
                    Name = doctor.Name,
                    FirstName__c = doctor.FirstName__c,
                    City__c = doctor.City__c,
                    Country__c = doctor.Country__c,
                    Email__c = doctor.Email__c,
                    Phone__c = doctor.Phone__c,
                    Street__c = doctor.Street__c);
            insert doctor;
        } else {
            update doctor;
        }

        return new ApexPages.StandardController(doctor).view();
    }
}