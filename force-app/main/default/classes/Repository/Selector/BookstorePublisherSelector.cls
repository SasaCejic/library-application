/*
* Class performs database selectors for Bookstore_Publisher__c junction object
*/
public with sharing class BookstorePublisherSelector implements CustomObject {
    /*
    * Method fetches all Bookstore_Publisher__c objects
    */
    public List<Bookstore_Publisher__c> getAllBookstorePublishers() {
        return [
            SELECT
                Id,
                Publisher__c,
                Bookstore__c
            FROM Bookstore_Publisher__c
        ];
    }
}