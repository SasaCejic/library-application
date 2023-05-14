/*
 * Class used as controller for Bookstore__c object
 */
public with sharing class BookstoreController {
    /**
     * Call BookstoreSearchService class method to get
     * all Bookstore__c records with names containing the specified searchKey
     * 
     * @param searchKey string value to search names by
     * 
     * @return list of Bookstore__c object records
     */
    @AuraEnabled(cacheable = true)
    public static List<Bookstore__c> getBookstoresByName(Id searchKey) {
        BookstoreSearchService service = (BookstoreSearchService) new ObjectFactory().createObject(BookstoreSearchService.class);

        service.getBookstoresByName(searchKey);

        return service.getResponse();
    }
}