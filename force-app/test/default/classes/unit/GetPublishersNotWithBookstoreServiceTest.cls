/*
 * Class used to perform unit tests for this service
 * Class will perform 3 tests: 1 positive, 1 negative and one for asserting method execution count for mockers
 */
@isTest
public with sharing class GetPublishersNotWithBookstoreServiceTest {
    @isTest
    public static void getPublishers_willReturnPublisher_ifBookstorePublisherNotCreated() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = new Bookstore_Publisher__c();

        // create mocks
        Mocker BookstorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getListByBookstoreId', new List<Bookstore_Publisher__c>{bookstorePublisherForTest});
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMock.getMock()
        );
        Mocker PublisherSelectorMock = new Mocker(PublisherSelector.class)
        .setBehavior('getListNotInIds', new List<Publisher__c>{publisherForTest});
        ObjectFactory.mocks.put(
            PublisherSelector.class.getName(),
            (PublisherSelector) PublisherSelectorMock.getMock()
        );

        // execute
        GetPublishersNotWithBookstoreService service = new GetPublishersNotWithBookstoreService();
        service.getPublishers(bookstoreForTest.Id);
        List<Publisher__c> publishersNotWorkingWithBookstore = service.getResponse();

        //assert
        Assert.areEqual(1, publishersNotWorkingWithBookstore.size());
    }

    @isTest
    public static void getPublishers_willNotReturnPublisher_ifBookstorePublisherWasCreated() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory.createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        
        // create mocks
        Mocker BookstorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getListByBookstoreId', new List<Bookstore_Publisher__c>{bookstorePublisherForTest});
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMock.getMock()
        );
        Mocker PublisherSelectorMock = new Mocker(PublisherSelector.class)
        .setBehavior('getListNotInIds', new List<Publisher__c>{});
        ObjectFactory.mocks.put(
            PublisherSelector.class.getName(),
            (PublisherSelector) PublisherSelectorMock.getMock()
        );

        // execute
        GetPublishersNotWithBookstoreService service = new GetPublishersNotWithBookstoreService();
        service.getPublishers(bookstoreForTest.Id);
        List<Publisher__c> publishersNotWorkingWithBookstore = service.getResponse();

        //assert
        Assert.areEqual(0, publishersNotWorkingWithBookstore.size());
    }

    @isTest
    public static void getPublishers_willUseCorrectSelectors() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory.createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);

        // create mocks
        Mocker BookstorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getListByBookstoreId', new List<Bookstore_Publisher__c>{bookstorePublisherForTest});
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMock.getMock()
        );
        Mocker PublisherSelectorMock = new Mocker(PublisherSelector.class)
        .setBehavior('getListNotInIds', new List<Publisher__c>{});
        ObjectFactory.mocks.put(
            PublisherSelector.class.getName(),
            (PublisherSelector) PublisherSelectorMock.getMock()
        );

        // execute
        GetPublishersNotWithBookstoreService service = new GetPublishersNotWithBookstoreService();
        service.getPublishers(bookstoreForTest.Id);

        // assert
        PublisherSelectorMock.assertMethodExecutionCount('getListNotInIds', 1);
        BookstorePublisherSelectorMock.assertMethodExecutionCount('getListByBookstoreId', 1);
    }
}