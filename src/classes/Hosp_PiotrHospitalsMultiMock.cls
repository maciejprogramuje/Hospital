global class Hosp_PiotrHospitalsMultiMock implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;

    global Hosp_PiotrHospitalsMultiMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    global HTTPResponse respond(HTTPRequest req) {
        System.debug('Hosp_PiotrHospitalsMultiMock -> req='+req);

        HttpCalloutMock mock = requests.get(req.getEndpoint());

        if (mock != null) {
            return mock.respond(req);
        } else {
            System.debug('Hosp_PiotrHospitalsMultiMock -> HTTP callout not supported for test methods. MOCK == null, req='+req);
            return null;
        }
    }

    global void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}


