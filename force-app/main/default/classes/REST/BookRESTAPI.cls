@RestResource(urlMapping='/api/Book__c/*')
global with sharing class BookRESTAPI {
    @HttpPost
    global static void doPost() {
        BookRestApiPostRequestService service = (BookRestApiPostRequestService) new ObjectFactory()
            .createObject(BookRestApiPostRequestService.class);
        service.insertBooks(RestContext.request, RestContext.response);
    }
}