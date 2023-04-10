public with sharing class BookstoreController {
    @AuraEnabled(cacheable = true)
    public static List<Bookstore__c> getStoresWithAuthorsBooks(){
        BookstoreService service = (BookstoreService) new ObjectFactory().createObject(BookstoreService.class);

        return service.getStoresWithAuthorsBooks();
    }
}