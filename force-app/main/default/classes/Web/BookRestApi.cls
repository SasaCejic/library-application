@RestResource(urlMapping='/api/Book__c/*')
global with sharing class BookRestApi {
    @HttpPost
    global static void doPost() {
        // Http request
        RestRequest req = RestContext.request;
        // Http response
        RestResponse res = RestContext.response;

        // execute
        InsertBooksPostRequestService service = (InsertBooksPostRequestService) new ObjectFactory()
            .createObject(InsertBooksPostRequestService.class);
        service.insertBooks(req);
        // Get response for http response
        InsertBooksPostRequestResponseDTO serviceResponse = service.getResponse();

        // set Http response
        res.addHeader('Content-Type', 'application/json');
        res.statusCode = serviceResponse.statusCode;
        res.responseBody = Blob.valueOf(JSON.serialize(serviceResponse));
    }
}