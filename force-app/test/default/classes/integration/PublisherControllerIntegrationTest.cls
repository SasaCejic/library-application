/*
 * This class tests publisher controller method
 */
@isTest
public with sharing class PublisherControllerIntegrationTest {
    @isTest
    public static void getPublishernotWorkingWithBookstore_willReturnPublisher_ifBookstorePublisherRecordIsNotInserted() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true, false);

        // execute
        Test.startTest();
        List<Publisher__c> publishersNotWorkingWithBookstore = PublisherController.getPublishersNotWorkingWithBookstore(bookstoreForTest.Id, 5);
        Test.stopTest();
        
        // assert
        Assert.areEqual(1, publishersNotWorkingWithBookstore.size());
    }
}