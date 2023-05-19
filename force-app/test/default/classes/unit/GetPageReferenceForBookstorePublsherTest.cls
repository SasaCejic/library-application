/**
 * Class used for testing GetPageReferenceForBookstorePublsherService
 */
@isTest
public with sharing class GetPageReferenceForBookstorePublsherTest {
    @isTest
    public static void getPageReference_willReturnPageRef_ifIsCanceledIsTrue() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        
        // execute
        GetPageReferenceForBookstorePublisher service = new GetPageReferenceForBookstorePublisher();
        service.getPageReference(true, false, false, bookstorePublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() != null);
    }

    @isTest
    public static void getPageReference_willReturnPageRef_ifDeleteStatusIsFalse() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        
        // execute
        GetPageReferenceForBookstorePublisher service = new GetPageReferenceForBookstorePublisher();
        service.getPageReference(false, false, false, bookstorePublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() != null);
    }

    @isTest
    public static void getPageReference_willReturnPageRef_ifviewAllIsClicked() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        
        // execute
        GetPageReferenceForBookstorePublisher service = new GetPageReferenceForBookstorePublisher();
        service.getPageReference(false, true, true, bookstorePublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() != null);
    }

    @isTest
    public static void getPageReference_willReturnNull_ifNoButtonsWereClickedAndDeleteStatusIsTrue() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        
        // execute
        GetPageReferenceForBookstorePublisher service = new GetPageReferenceForBookstorePublisher();
        service.getPageReference(false, false, true, bookstorePublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() == null);
    }
}