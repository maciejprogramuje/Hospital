public with sharing class Hosp_UtilsConvertErrorMessages {
    public static String convert(String errorMsg) {
        if(errorMsg.contains('Duplicate record')) {
            errorMsg = Label.Hosp_Duplicate_Record;
        }

        return errorMsg;
    }
}