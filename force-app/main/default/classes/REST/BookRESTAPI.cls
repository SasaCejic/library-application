@RestResource(urlMapping='/api/Book__c/*')
global with sharing class BookRESTAPI {
    @HttpPost
    global static void doPost() {
        InsertBooksForRESTAPIService service = (InsertBooksForRESTAPIService) new ObjectFactory()
            .createObject(InsertBooksForRESTAPIService.class);
        service.insertBooks(RestContext.request, RestContext.response);
    }
}