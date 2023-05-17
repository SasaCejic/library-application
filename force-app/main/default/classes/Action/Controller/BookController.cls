/*
 * Class used as controller for Book__c object
 */
public with sharing class BookController {
    /*
     * @param bookstoreId - Id of bookstore and based on the id retrieves all the books not in the bookstore
     * @param limit - Maximum number of records to return
     */
    @AuraEnabled(cacheable=true)
    public static List<Book__c> getBooksNotInBookstore(Id bookstoreId, Integer recordLimit) {
        GetBooksNotInBookstoreService service = (GetBooksNotInBookstoreService) new ObjectFactory()
            .createObject(GetBooksNotInBookstoreService.class);
        service.getBooks(bookstoreId, recordLimit);
        return service.getResponse();
    }

    /**
     * Call BookService class method to get
     * Book__c record with certain Id value
     * 
     * @param bookId certain book id
     * 
     * @return Book__c object record
     */
    @AuraEnabled(cacheable = true)
    public static Book__c getBookById(Id bookId) {
        BookService service = (BookService) new ObjectFactory().createObject(BookService.class);

        service.getBookById(bookId);

        return service.getResponse();
    }
}