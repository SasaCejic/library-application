public with sharing class BookstoreBookController {
    @AuraEnabled(cacheable = true)
    public static List<Bookstore_Book__c> getBookstoreBooksWithAuthorsBooks(Id authorId){
        BookstoreBookService service = (BookstoreBookService) new ObjectFactory().createObject(BookstoreBookService.class);

        return service.getBookstoreBooksWithAuthorsBooks(authorId);
    }
}