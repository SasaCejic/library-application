/*
* Class performs database selectors for Bookstore_Publisher__c junction object
*/
public with sharing class BookstorePublisherSelector implements CustomObject {
    /*
    * Method fetches the Bookstore_Publisher__c(Junction) object that has provided publisherId and bookStore Id 
    */
    public List<Bookstore_Publisher__c> getBookstorePublishersWithPublisherAndBookstoreId(String soqlQuery) {
        return Database.query(soqlQuery);
    }
}