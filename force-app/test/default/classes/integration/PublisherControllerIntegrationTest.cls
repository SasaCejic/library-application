/*
* This class tests publisher controller methods
*/
@isTest
public with sharing class PublisherControllerIntegrationTest {
    @isTest
    public static void getPublishernotWorkingWithBookstore_willNotReturnAnyPublishers_ifBookstorePublisherRecordIsInserted() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, true, false);

        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'bookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1241353');
        Bookstore__c bookstoreForTest = testFactory.createBookstore(bookstoreDetails, true, false);

        Bookstore_Publisher__c bookstorePublisherForTest = testFactory.createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true, false);

        Test.startTest();
        List<Publisher__c> publishersNotWorkingWithBookstore = PublisherController.getPublishersNotWorkingWithBookstore(bookstoreForTest.Id);
        Test.stopTest();
        
        System.assertEquals(0, publishersNotWorkingWithBookstore.size());
    }
}