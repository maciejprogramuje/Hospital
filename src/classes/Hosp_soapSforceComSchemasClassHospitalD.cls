//Generated by wsdl2apex

public class Hosp_soapSforceComSchemasClassHospitalD {
    public class getDoctors_element {
        public String firstName;
        public String lastName;
        public String city;
        public String country;
        private String[] firstName_type_info = new String[]{'firstName','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','true'};
        private String[] lastName_type_info = new String[]{'lastName','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','true'};
        private String[] city_type_info = new String[]{'city','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','true'};
        private String[] country_type_info = new String[]{'country','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'firstName','lastName','city','country'};
    }
    public class LogInfo {
        public String category;
        public String level;
        private String[] category_type_info = new String[]{'category','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] level_type_info = new String[]{'level','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'category','level'};
    }
    public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }
    public class address {
        public String city;
        public String country;
        public String countryCode;
        public String geocodeAccuracy;
        public String postalCode;
        public String state;
        public String stateCode;
        public String street;
        private String[] city_type_info = new String[]{'city','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] country_type_info = new String[]{'country','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] countryCode_type_info = new String[]{'countryCode','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] geocodeAccuracy_type_info = new String[]{'geocodeAccuracy','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] postalCode_type_info = new String[]{'postalCode','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] state_type_info = new String[]{'state','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] stateCode_type_info = new String[]{'stateCode','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] street_type_info = new String[]{'street','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'city','country','countryCode','geocodeAccuracy','postalCode','state','stateCode','street'};
    }
    public class deleteDoctorsResponse_element {
        public Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class getDoctorsResponse_element {
        public Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class CallOptions_element {
        public String client;
        private String[] client_type_info = new String[]{'client','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'client'};
    }
    public class DebuggingHeader_element {
        public Hosp_soapSforceComSchemasClassHospitalD.LogInfo[] categories;
        public String debugLevel;
        private String[] categories_type_info = new String[]{'categories','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'0','-1','false'};
        private String[] debugLevel_type_info = new String[]{'debugLevel','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'categories','debugLevel'};
    }
    public class upsertDoctor_element {
        public String doctorId;
        public String firstName;
        public String lastName;
        public String city;
        public String country;
        private String[] doctorId_type_info = new String[]{'doctorId','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','true'};
        private String[] firstName_type_info = new String[]{'firstName','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','true'};
        private String[] lastName_type_info = new String[]{'lastName','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','true'};
        private String[] city_type_info = new String[]{'city','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','true'};
        private String[] country_type_info = new String[]{'country','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'doctorId','firstName','lastName','city','country'};
    }
    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    public class upsertDoctorResponse_element {
        public Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class location {
        public Double latitude;
        public Double longitude;
        private String[] latitude_type_info = new String[]{'latitude','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] longitude_type_info = new String[]{'longitude','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'latitude','longitude'};
    }
    public class AllowFieldTruncationHeader_element {
        public Boolean allowFieldTruncation;
        private String[] allowFieldTruncation_type_info = new String[]{'allowFieldTruncation','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'allowFieldTruncation'};
    }
    public class deleteDoctors_element {
        public String[] doctorsId;
        private String[] doctorsId_type_info = new String[]{'doctorsId','http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP','true','false'};
        private String[] field_order_type_info = new String[]{'doctorsId'};
    }
    public class Hospital_DoctorsSOAP {
        public String endpoint_x = 'https://eu16.salesforce.com/services/Soap/class/Hospital_DoctorsSOAP';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public Hosp_soapSforceComSchemasClassHospitalD.CallOptions_element CallOptions;
        public Hosp_soapSforceComSchemasClassHospitalD.DebuggingHeader_element DebuggingHeader;
        public Hosp_soapSforceComSchemasClassHospitalD.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        public Hosp_soapSforceComSchemasClassHospitalD.DebuggingInfo_element DebuggingInfo;
        public Hosp_soapSforceComSchemasClassHospitalD.SessionHeader_element SessionHeader;
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP';
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP', 'Hosp_soapSforceComSchemasClassHospitalD', 'http://soap.sforce.com/schemas/class/Hospital_DoctorWrapperForSOAP', 'Hosp_soapSforceComSchemasClassHospitalDW'};
        public Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP[] deleteDoctors(String[] doctorsId) {
            Hosp_soapSforceComSchemasClassHospitalD.deleteDoctors_element request_x = new Hosp_soapSforceComSchemasClassHospitalD.deleteDoctors_element();
            request_x.doctorsId = doctorsId;
            Hosp_soapSforceComSchemasClassHospitalD.deleteDoctorsResponse_element response_x;
            Map<String, Hosp_soapSforceComSchemasClassHospitalD.deleteDoctorsResponse_element> response_map_x = new Map<String, Hosp_soapSforceComSchemasClassHospitalD.deleteDoctorsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',
              'deleteDoctors',
              'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',
              'deleteDoctorsResponse',
              'Hosp_soapSforceComSchemasClassHospitalD.deleteDoctorsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP upsertDoctor(String doctorId,String firstName,String lastName,String city,String country) {
            Hosp_soapSforceComSchemasClassHospitalD.upsertDoctor_element request_x = new Hosp_soapSforceComSchemasClassHospitalD.upsertDoctor_element();
            request_x.doctorId = doctorId;
            request_x.firstName = firstName;
            request_x.lastName = lastName;
            request_x.city = city;
            request_x.country = country;
            Hosp_soapSforceComSchemasClassHospitalD.upsertDoctorResponse_element response_x;
            Map<String, Hosp_soapSforceComSchemasClassHospitalD.upsertDoctorResponse_element> response_map_x = new Map<String, Hosp_soapSforceComSchemasClassHospitalD.upsertDoctorResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',
              'upsertDoctor',
              'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',
              'upsertDoctorResponse',
              'Hosp_soapSforceComSchemasClassHospitalD.upsertDoctorResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public Hosp_soapSforceComSchemasClassHospitalDW.Hospital_DoctorWrapperForSOAP[] getDoctors(String firstName,String lastName,String city,String country) {
            Hosp_soapSforceComSchemasClassHospitalD.getDoctors_element request_x = new Hosp_soapSforceComSchemasClassHospitalD.getDoctors_element();
            request_x.firstName = firstName;
            request_x.lastName = lastName;
            request_x.city = city;
            request_x.country = country;
            Hosp_soapSforceComSchemasClassHospitalD.getDoctorsResponse_element response_x;
            Map<String, Hosp_soapSforceComSchemasClassHospitalD.getDoctorsResponse_element> response_map_x = new Map<String, Hosp_soapSforceComSchemasClassHospitalD.getDoctorsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',
              'getDoctors',
              'http://soap.sforce.com/schemas/class/Hospital_DoctorsSOAP',
              'getDoctorsResponse',
              'Hosp_soapSforceComSchemasClassHospitalD.getDoctorsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
}