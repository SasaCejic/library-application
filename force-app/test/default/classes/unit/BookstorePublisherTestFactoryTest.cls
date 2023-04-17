/*
* Class used for testing the class that creates Bookstore_Publisher__c objects used only in tests written for other classes
*/
@isTest
public with sharing class BookstorePublisherTestFactoryTest {
    /*
    * Id used is dummy 18 character Id used for creating the records without inserting
    */
    @isTest
    public static void createBookstorePublishers_willCreateFiveBookstorePublishers() {
        Test.startTest();
        List<Bookstore_Publisher__c> bkStorePublishers = new BookstorePublisherTestFactory().createBookstorePublishers(5, 'a043N00000BRi9rQAD', 'a043N00000BRi9rQAD');
        Test.stopTest();
        System.assertEquals(5, bkStorePublishers.size());
    }
}