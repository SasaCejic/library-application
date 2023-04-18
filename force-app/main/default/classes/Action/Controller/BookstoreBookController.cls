public with sharing class BookstoreBookController {
    @AuraEnabled(cacheable = true)
    public static AggregateResult[] getBookstoreBooksWithAuthorsBooks(Id authorId){
        BookstoreBookService service = (BookstoreBookService) new ObjectFactory().createObject(BookstoreBookService.class);

        return service.getBookstoreBooksWithAuthorsBooks(authorId);
    }
}