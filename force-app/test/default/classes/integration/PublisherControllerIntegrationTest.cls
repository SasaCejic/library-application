/*
 * This class tests publisher controller methods
 */
@isTest
public with sharing class PublisherControllerIntegrationTest {
    @isTest
    public static void getPublishernotWorkingWithBookstore_willReturnPublisher_ifBookstorePublisherRecordIsNotInserted() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true, false);

        Test.startTest();
        List<Publisher__c> publishersNotWorkingWithBookstore = PublisherController.getPublishersNotWorkingWithBookstore(bookstoreForTest.Id);
        Test.stopTest();
        
        Assert.areEqual(1, publishersNotWorkingWithBookstore.size());
    }
}