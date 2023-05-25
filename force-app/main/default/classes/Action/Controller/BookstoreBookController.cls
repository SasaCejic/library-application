/**
 * Class used as Bookstore_Book__c object controller
 */
public with sharing class BookstoreBookController {
    /**
     * @param bookstorePublisherForDeleteId - Id of the Bookstore_Publisher__c record being deleted
     * @param recordLimit - Number of Bookstore_Book__c records to be retrieved from database
     */
    @AuraEnabled(cacheable = true)
    public static List<Bookstore_Book__c> returnBookstoreBooksCausingErrorOnPublisherDelete(Id bookstorePublisherForDeleteId, Integer recordLimit) {
        GetBookstoreBookOnPublsherDeleteService service = (GetBookstoreBookOnPublsherDeleteService) new ObjectFactory()
            .createObject(GetBookstoreBookOnPublsherDeleteService.class);
        service.getBookstoreBooks(bookstorePublisherForDeleteId, recordLimit);
        return service.getResponse();
    }
}