/*
 * Class used as controller for Book__c object
 */
public with sharing class BookController {
    /**
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
     * Method sends email to the user that bought the book
     * @param emailAddress - email address of the user that bought the book
     * @param bookName - name of the book user bought
     * @param bookPrice - price of the book user bought
     * @param bookId - Id of the book user bought
     */
    @AuraEnabled
    public static void confirmDigitalBookPurchase(String emailAddress, string bookName, String bookPrice, Id bookId) {
        //Insert purchase record into database
        InsertBookPurchaseRecordService insertService = (InsertBookPurchaseRecordService) new ObjectFactory()
            .createObject(InsertBookPurchaseRecordService.class);
        insertService.insertPurchase(bookId);
        // Send email to user
        SendPurchaseEmailConfirmationService service = (SendPurchaseEmailConfirmationService) new ObjectFactory()
            .createObject(SendPurchaseEmailConfirmationService.class);
        service.sendMail(insertService.getResponse().isSuccess(), emailAddress, bookName, bookPrice);
    }

    /**
     * @param authorPublisherForDeleteId - Id of the Author_Publisher__c record being deleted
     * @param recordLimit - Number of Book__c records to be retrieved from database
     */
    @AuraEnabled(cacheable = true)
    public static List<Book__c> returnBooksCausingErrorOnAuthPubDel(Id authorPublisherForDeleteId, Integer recordLimit) {
        GetRelatedBooksOnAuthPubDelService service = (GetRelatedBooksOnAuthPubDelService) new ObjectFactory()
            .createObject(GetRelatedBooksOnAuthPubDelService.class);
        service.getRelatedBooks(authorPublisherForDeleteId, recordLimit);
        return service.getResponse();
    }
}
