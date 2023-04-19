/*
* Class performs database selectors for Bookstore_Publisher__c junction object
*/
public with sharing class BookstorePublisherSelector implements CustomObject {
    /*
    * Method fetches the Bookstore_Publisher__c(Junction) object that has provided publisherId and bookStore Id
    * @param publishersAndBookstoreIds - List of lists that holds pairs of publisher and bookstore ids to fetch all the Bookstore_Publisher__c objects corresponding to those pairs
    */
    public List<Bookstore_Publisher__c> getBookstorePublishersWithPublisherAndBookstoreId(List<List<Id>> publisherAndBookstoreIds) {
        // Build the dynamic SOQL query
        String soqlQuery = 'SELECT Id, Publisher__c, Bookstore__c FROM Bookstore_Publisher__c WHERE ';
        for (List<Id> listId : publisherAndBookstoreIds) {
            soqlQuery += '(Publisher__c = \'' + listId[0] + '\' AND Bookstore__c = \'' + listId[1] + '\') OR ';
        }
        soqlQuery = soqlQuery.removeEnd(' OR ');
        return Database.query(soqlQuery);
    }
}