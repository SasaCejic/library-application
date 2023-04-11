public with sharing class BookstoreController {
    @AuraEnabled(cacheable = true)
    public static List<Bookstore__c> getBookstoresWithAuthorsBooks(Id authorId){
        BookstoreService service = (BookstoreService) new ObjectFactory().createObject(BookstoreService.class);

        return service.getBookstoresWithAuthorsBooks(authorId);
    }
}