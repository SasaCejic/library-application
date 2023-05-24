@RestResource(urlMapping='/api/Book__c/*')
global with sharing class BookRestApi {
    @HttpPost
    global static void doPost() {
        System.debug('uslo');
        BookRestApiPostRequestService service = (BookRestApiPostRequestService) new ObjectFactory()
            .createObject(BookRestApiPostRequestService.class);
        service.insertBooks();
    }
}