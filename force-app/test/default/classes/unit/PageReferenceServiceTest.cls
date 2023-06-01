/**
 * Class used for testing GetPageReferenceForBookstorePublsherService
 */
@isTest
public with sharing class PageReferenceServiceTest {
    @isTest
    public static void getPageReferenceForBookstorePublisher_willReturnPageRef_ifIsCanceledIsTrue() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true);

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
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true);

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
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true);

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
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true);
    
        // execute
        PageReferenceService service = new PageReferenceService();
        service.getPageReferenceForBookstorePublisher(false, false, true, bookstorePublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() == null);
    }

    @isTest
    public static void getPageReferenceForAuthorPublisher_willReturnPageRef_ifIsCanceledIsTrue() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, authorForTest.Id, true);

        // execute
        PageReferenceService service = new PageReferenceService();
        service.getPageReferenceForAuthorPublisher(true, false, false, authorPublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() != null);
        Assert.areEqual(service.getResponse().getUrl(), '/' + authorForTest.Id);
    }

    @isTest
    public static void getPageReferenceForAuthorPublisher_willReturnPageRef_ifDeleteStatusIsFalse() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(publisherForTest.Id, authorForTest.Id, true);

        // execute
        PageReferenceService service = new PageReferenceService();
        service.getPageReferenceForAuthorPublisher(false, false, false, authorPublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() != null);
        Assert.areEqual(service.getResponse().getUrl(), '/' + authorForTest.Id);
    }

    @isTest
    public static void getPageReferenceForAuthorPublisher_willReturnPageRef_ifviewAllIsClicked() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(publisherForTest.Id, authorForTest.Id, true);

        // execute
        PageReferenceService service = new PageReferenceService();
        service.getPageReferenceForAuthorPublisher(false, true, true, authorPublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() != null);
        Assert.areEqual(service.getResponse().getUrl(), '/lightning/n/Books_preventing_author_removal?c__recordId=' + authorPublisherForTest.Id);
    }

    @isTest
    public static void getPageReferenceForAuthorPublisher_willReturnNull_ifNoButtonsWereClickedAndDeleteStatusIsTrue() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(publisherForTest.Id, authorForTest.Id, true);
    
        // execute
        PageReferenceService service = new PageReferenceService();
        service.getPageReferenceForAuthorPublisher(false, false, true, authorPublisherForTest);

        // Assert
        Assert.isTrue(service.getResponse() == null);
    }
}