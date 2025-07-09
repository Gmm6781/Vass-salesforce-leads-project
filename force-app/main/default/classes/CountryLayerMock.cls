@isTest
global class CountryLayerMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Crear respuesta simulada (JSON con datos de países)
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"countries":[{"name":"Testland","alpha2Code":"TL","alpha3Code":"TST","capital":"Test City","region":"Test Region","regionalBlocs":[{"acronym":"TBloc"}]}]}');
        res.setStatusCode(200);
        return res;
    }
}