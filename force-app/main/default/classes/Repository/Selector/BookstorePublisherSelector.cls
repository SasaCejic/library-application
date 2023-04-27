/*
* Class performs database selectors for Bookstore_Publisher__c junction object
*/
public with sharing class BookstorePublisherSelector implements CustomObject {
    /*
    * Method fetches all Bookstore_Publisher__c objects
    */

    public List<Bookstore_Publisher__c> getList() {
        return [
            SELECT
                Id,
                Publisher__c,
                Bookstore__c
            FROM Bookstore_Publisher__c
        ];
    }
    
    /*
    * Method returns all Bookstore_Publisher__c records working with Bookstore
    * @param boosktoreId - id of Bookstore
    */

    public List<Bookstore_Publisher__c> getListByBookstoreId(Id bookstoreId) {
        return [
            SELECT
                Id,
                Publisher__c,
                Bookstore__c
            FROM Bookstore_Publisher__c
            WHERE Bookstore__c = : bookstoreId
        ];
    }
}