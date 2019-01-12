public with sharing class Hosp_DoctorsSorting {
    public static Boolean sortAscending { get; set; }
    public static String compareBy { get; set; }

    public static List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> sortResults(List<Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP> doctorsToSort) {
        List<Hosp_DoctorsSorting.DoctorWrapper> tempDoctorsToSort = new List<Hosp_DoctorsSorting.DoctorWrapper>();

        for (Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctorToConvert : doctorsToSort) {
            tempDoctorsToSort.add(new Hosp_DoctorsSorting.DoctorWrapper(doctorToConvert));
        }

        tempDoctorsToSort.sort();

        doctorsToSort.clear();
        for (Hosp_DoctorsSorting.DoctorWrapper doc : tempDoctorsToSort) {
            Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctorInWrapper = new Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP();
            doctorInWrapper.webServiceDoctorLastName = doc.name;
            doctorInWrapper.webServiceDoctorFirstName = doc.firstName;
            doctorInWrapper.webServiceDoctorCity = doc.city;
            doctorInWrapper.webServiceDoctorCountry = doc.country;


            doctorsToSort.add(doctorInWrapper);
        }

        return doctorsToSort;
    }

    public class DoctorWrapper implements Comparable {
        public String name { get; set; }
        public String firstName { get; set; }
        public String country { get; set; }
        public String city { get; set; }


        public DoctorWrapper(Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP doctorToChange) {
            name = doctorToChange.webServiceDoctorLastName;
            firstName = doctorToChange.webServiceDoctorFirstName;
            country = doctorToChange.webServiceDoctorCountry;
            city = doctorToChange.webServiceDoctorCity;

            if(String.isBlank(name)) {
                name = '';
            }
            if(String.isBlank(firstName)) {
                firstName = '';
            }
            if(String.isBlank(country)) {
                country = '';
            }
            if(String.isBlank(city)) {
                city = '';
            }
        }

        public Integer compareTo(Object compareTo) {
            if (sortAscending) {
                if (compareBy.equals('name')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (name == compareToDoctor.name) return 0;
                    if (name > compareToDoctor.name) return 1;
                    return -1;
                } else if (compareBy.equals('firstName')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (firstName == compareToDoctor.firstName) return 0;
                    if (firstName > compareToDoctor.firstName) return 1;
                    return -1;
                } else if (compareBy.equals('country')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (country == compareToDoctor.country) return 0;
                    if (country > compareToDoctor.country) return 1;
                    return -1;
                } else {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (city == compareToDoctor.city) return 0;
                    if (city > compareToDoctor.city) return 1;
                    return -1;
                }
            } else {
                if (compareBy.equals('name')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (name == compareToDoctor.name) return 0;
                    if (name > compareToDoctor.name) return -1;
                    return 1;
                } else if (compareBy.equals('firstName')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (firstName == compareToDoctor.firstName) return 0;
                    if (firstName > compareToDoctor.firstName) return -1;
                    return 1;
                } else if (compareBy.equals('country')) {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (country == compareToDoctor.country) return 0;
                    if (country > compareToDoctor.country) return -1;
                    return 1;
                } else {
                    DoctorWrapper compareToDoctor = (DoctorWrapper) compareTo;
                    if (city == compareToDoctor.city) return 0;
                    if (city > compareToDoctor.city) return -1;
                    return 1;
                }
            }
        }
    }
}