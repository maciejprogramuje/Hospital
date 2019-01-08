/**
 * Created by BRITENET on 08.01.2019.
 */

global class Hosp_PiotrHospitalsMultiMock implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;

    global Hosp_PiotrHospitalsMultiMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    global HTTPResponse respond(HTTPRequest req) {
        HttpCalloutMock mock = requests.get(req.getEndpoint());

        if (mock != null) {
            return mock.respond(req);
        } else {
            System.debug('HTTP callout not supported for test methods. MOCK == null');
            return null;
        }
    }

    global void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}


