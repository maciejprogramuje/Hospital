public class Hosp_Utils {

    public static String getAccessToken(String username, String password, String ClientId, String ClientSecret) {
        String endpoint = 'https://login.salesforce.com/services/oauth2/token';

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        req.setBody('grant_type=password' +
                '&client_id=' + ClientId +
                '&client_secret=' + ClientSecret +
                '&username=' + username +
                '&password=' + password
        );
        req.setEndpoint(endpoint);
        Http http = new Http();
        HttpResponse res;
        String accessToken;
        try {
            res = http.send(req);
            system.debug('body:' + res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    accessToken = parser.getText();
                }
            }
        } catch (system.CalloutException e) {
            System.debug('error >>> ' + e);
        }

        return accessToken;
    }

}