/*
* Class used for creating Bookstore_Publisher__c objects only for tests
*/
@isTest
public with sharing class BookstorePublisherTestFactory {
    /*
    * @param numOfbkStorePublishers - number of objects to be created
    * @param publisherId - Id of a Publisher__c which is a parent in master-detail relationship
    * @param bookstoreId - Id of a Bookstore__c which is a parent in master-detail relationship
    */
    public List<Bookstore_Publisher__c> createBookstorePublishers(Integer numOfbkStorePublishers,
    Id publisherId, Id bookstoreId) {
        List<Bookstore_Publisher__c> BookstorePublishersForTest = new List<Bookstore_Publisher__c>();
        for(Integer i = 0; i<numOfbkStorePublishers; i++) {
            Bookstore_Publisher__c currentBkstorePublisher = new Bookstore_Publisher__c();
            currentBkstorePublisher.Publisher__c = publisherId;
            currentBkstorePublisher.Bookstore__c = bookstoreId;
            BookstorePublishersForTest.add(currentBkstorePublisher);
        }
        return BookstorePublishersForTest;
    }
}