/*
 * Class used as controller for Publisher__c object
 */
public with sharing class PublisherController {
    /*
     * @param bookstoreId - based on this bookstore Id retrieves all the publishers not working with the bookstore
     */
    @AuraEnabled(cacheable=true)
    public static List<Publisher__c> getPublishersNotWorkingWithBookstore(Id bookstoreId, Integer recordLimit) {
        GetPublishersNotWithBookstoreService service = (GetPublishersNotWithBookstoreService) new ObjectFactory()
            .createObject(GetPublishersNotWithBookstoreService.class);
        service.getPublishers(bookstoreId, recordLimit);
        return service.getResponse();
    }
}