global class Hosp_UtilToSortHospitals {
    public static Boolean sortAscending { get; set; }
    public static String compareBy { get; set; }

    global class HospitalWrapper implements Comparable {
        private String name { get; set; }
        private String country { get; set; }
        private String city { get; set; }
        private String postalCode { get; set; }
        private String street { get; set; }

        global HospitalWrapper(Hosp_HospitalWrapperForRest hospitalToChange) {
            name = hospitalToChange.name;
            country = hospitalToChange.country;
            city = hospitalToChange.city;
            postalCode = hospitalToChange.postalCode;
            street = hospitalToChange.street;
        }

        global Integer compareTo(Object compareTo) {
            if (sortAscending) {
                if (compareBy.equals('name')) {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (name == compareToHospital.name) return 0;
                    if (name > compareToHospital.name) return 1;
                    return -1;
                } else if (compareBy.equals('country')) {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (country == compareToHospital.country) return 0;
                    if (country > compareToHospital.country) return 1;
                    return -1;
                } else {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (city == compareToHospital.city) return 0;
                    if (city > compareToHospital.city) return 1;
                    return -1;
                }
            } else {
                if (compareBy.equals('name')) {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (name == compareToHospital.name) return 0;
                    if (name > compareToHospital.name) return -1;
                    return 1;
                } else if (compareBy.equals('country')) {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (country == compareToHospital.country) return 0;
                    if (country > compareToHospital.country) return -1;
                    return 1;
                } else {
                    HospitalWrapper compareToHospital = (HospitalWrapper) compareTo;
                    if (city == compareToHospital.city) return 0;
                    if (city > compareToHospital.city) return -1;
                    return 1;
                }
            }
        }
    }
}