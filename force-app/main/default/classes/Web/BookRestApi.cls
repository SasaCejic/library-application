@RestResource(urlMapping='/api/Book__c/*')
global with sharing class BookRestApi {
    @HttpPost
    global static void doPost() {
        // Http request
        RestRequest req = RestContext.request;
        // Http response
        RestResponse res = RestContext.response;

        // execute
        BookRestApiPostRequestService service = (BookRestApiPostRequestService) new ObjectFactory()
            .createObject(BookRestApiPostRequestService.class);
        service.insertBooks(req);
        // Get response for http response
        BookRestApiResponseDTO serviceResponse = service.getResponse();
        
        // set response
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(serviceResponse));
    }
}