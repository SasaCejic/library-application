/*
* Class performs database selectors for Bookstore_Publisher__c junction object
*/
public with sharing class BookstorePublisherSelector implements CustomObject {
    /*
    * Method fetches the Bookstore_Publisher__c(Junction) object that has provided publisherId and bookStore Id
    * @param publisherId - Id of the publisher assigned to the bookstore
    * @param bookstoreId - Id of the bookstore 
    */
    public List<Bookstore_Publisher__c> getBookstorePublisherByPublisherIdAndBookstoreId(Id publisherId, Id bookStoreId) {
        return [
            SELECT
                Id
            FROM Bookstore_Publisher__c
            WHERE Publisher__c =: publisherId
            AND Bookstore__c =: bookStoreId
        ];
    }
}