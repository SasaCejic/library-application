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
    
    /**
     * Call PublisherSearchService class method to get
     * all Publisher__c records with names containing the specified searchKey
     * 
     * @param searchKey string value to search names by
     * 
     * @return list of Publisher__c object records
     */
    @AuraEnabled(cacheable = true)
    public static List<Publisher__c> getPublishersByName(Id searchKey) {
        PublisherSearchService service = (PublisherSearchService) new ObjectFactory().createObject(PublisherSearchService.class);

        service.getPublishersByName(searchKey);

        return service.getResponse();
    }
}