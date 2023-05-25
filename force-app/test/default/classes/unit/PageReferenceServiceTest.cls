/**
 * Class used for testing GetPageReferenceForBookstorePublsherService
 */
@isTest
public with sharing class PageReferenceServiceTest {
    @isTest
    public static void getPageReferenceForBookstorePublisher_willReturnPageRef_ifIsCanceledIsTrue() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);

        // execute
        PageReferenceService service = new PageReferenceService();
        service.getPageReferenceForBookstorePublisher(true, false, false, bookstorePublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() != null);
        Assert.areEqual(service.getResponse().getUrl(), '/' + bookstoreForTest.Id);
    }

    @isTest
    public static void getPageReferenceForBookstorePublisher_willReturnPageRef_ifDeleteStatusIsFalse() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);

        // execute
        PageReferenceService service = new PageReferenceService();
        service.getPageReferenceForBookstorePublisher(false, false, false, bookstorePublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() != null);
        Assert.areEqual(service.getResponse().getUrl(), '/' + bookstoreForTest.Id);
    }

    @isTest
    public static void getPageReferenceForBookstorePublisher_willReturnPageRef_ifviewAllIsClicked() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);

        // execute
        PageReferenceService service = new PageReferenceService();
        service.getPageReferenceForBookstorePublisher(false, true, true, bookstorePublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() != null);
        Assert.areEqual(service.getResponse().getUrl(), '/lightning/n/Books_preventing_publisher_removal?c__recordId=' + bookstorePublisherForTest.Id);
    }

    @isTest
    public static void getPageReferenceForBookstorePublisher_willReturnNull_ifNoButtonsWereClickedAndDeleteStatusIsTrue() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
    
        // execute
        PageReferenceService service = new PageReferenceService();
        service.getPageReferenceForBookstorePublisher(false, false, true, bookstorePublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() == null);
    }
}