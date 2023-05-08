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

    /*
     * Method returns searched digital books
     * @param searchTerm - Name of the searched book
     */
    @AuraEnabled(cacheable=true)
    public static List<Book__c> getDigitalBooks(String searchTerm) {
        GetDigitalBooksService digitalBooksService = (GetDigitalBooksService) new ObjectFactory()
            .createObject(GetDigitalBooksService.class);
        digitalBooksService.getBooks(searchTerm);
        return digitalBooksService.getResponse();
    }

    /*
     * Method sends email to the user that bought the book
     * @param emailAddress - email address of the user that bought the book
     * @param bookName - name of the book user bought
     * @param bookPrice - price of the book user bought
     */
    @AuraEnabled
    public static void sendPurchaseMailConfirmation(String emailAddress, string bookName, String bookPrice) {
        SendPurchaseEmailConfirmationService service = (SendPurchaseEmailConfirmationService) new ObjectFactory()
            .createObject(SendPurchaseEmailConfirmationService.class);
        service.sendMail(emailAddress, bookName, bookPrice);
    }
}