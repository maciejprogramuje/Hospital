/**
 * Created by BRITENET on 08.01.2019.
 */

@isTest
public class Hosp_PiotrHospitalsControllerTest {

    @isTest
    static void shouldGetHospitals() {
        Map<String, String> header = new Map<String, String>();
        header.put('sessionId', '');
        Hosp_PiotrHospitalSingleMock fakeHospitalResp = new Hosp_PiotrHospitalSingleMock(200,
                'Complete', '[{"name": "HospitalTest","country": "PL","city": "Lublin","postalCode": "22-222","street": "Zana"}]',
                header);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://eu16.salesforce.com/services/apexrest/Hospital__c/?Name=HospitalTest&City__c=Lublin&Country__c=PL', fakeHospitalResp);

        HttpCalloutMock multiCalloutMock = new Hosp_PiotrHospitalsMultiMock(endpoint2TestResp);
        System.debug('multiCalloutMock' + multiCalloutMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Hosp_PiotrHospitalsController controller = new Hosp_PiotrHospitalsController();
        String name = 'HospitalTest';
        String country = 'PL';
        String city = 'Lublin';

        Hospital__c hospital = new Hospital__c(Name = name, Country__c = country, City__c = city);
        controller.hospitalToSearch = hospital;
        List<Hosp_HospitalWrapperForRest> hospitals = new List<Hosp_HospitalWrapperForRest>();

        controller.searchHospitals();
        hospitals = controller.hospitalsResults;

        System.assertEquals('HospitalTest', hospitals.get(0).name);
    }
}


