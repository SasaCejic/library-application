/*
* Class used to perform unit tests for this service
* Class will perform 3 tests: 1 positive, 1 negative and one for asserting method execution count for mockers
*/
@isTest
public with sharing class GetPublishersNotWithBookstoreServiceTest {
    @isTest
    public static void getPublishers_willReturnPublisher_ifBookstorePublisherNotCreated() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);

        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'bookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1241353');
        Bookstore__c bookstoreForTest = testFactory.createBookstore(bookstoreDetails, false, true);

        Bookstore_Publisher__c bookstorePublisherForTest = new Bookstore_Publisher__c();

        Mocker BookstorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getListByBookstoreId', new List<Bookstore_Publisher__c>{bookstorePublisherForTest});

        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMock.getMock()
        );

        Mocker PublisherSelectorMock = new Mocker(PublisherSelector.class)
        .setBehavior('getPublishersNotInSet', new List<Publisher__c>{publisherForTest});
        
        ObjectFactory.mocks.put(
            PublisherSelector.class.getName(),
            (PublisherSelector) PublisherSelectorMock.getMock()
        );

        GetPublishersNotWithBookstoreService service = new GetPublishersNotWithBookstoreService();
        service.getPublishers(bookstoreForTest.Id);
        List<Publisher__c> publishersNotWorkingWithBookstore = service.getResponse();

        System.assertEquals(1, publishersNotWorkingWithBookstore.size());
    }

    @isTest
    public static void getPublishers_willNotReturnPublisher_ifBookstorePublisherWasCreated() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);

        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'bookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1241353');
        Bookstore__c bookstoreForTest = testFactory.createBookstore(bookstoreDetails, false, true);

        Bookstore_Publisher__c bookstorePublisherForTest = testFactory.createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);

        Mocker BookstorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getListByBookstoreId', new List<Bookstore_Publisher__c>{bookstorePublisherForTest});

        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMock.getMock()
        );

        Mocker PublisherSelectorMock = new Mocker(PublisherSelector.class)
        .setBehavior('getPublishersNotInSet', new List<Publisher__c>{});
        
        ObjectFactory.mocks.put(
            PublisherSelector.class.getName(),
            (PublisherSelector) PublisherSelectorMock.getMock()
        );

        GetPublishersNotWithBookstoreService service = new GetPublishersNotWithBookstoreService();
        service.getPublishers(bookstoreForTest.Id);
        List<Publisher__c> publishersNotWorkingWithBookstore = service.getResponse();

        System.assertEquals(0, publishersNotWorkingWithBookstore.size());
    }

    @isTest
    public static void getPublishers_willUseCorrectSelectors() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);

        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'bookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1241353');
        Bookstore__c bookstoreForTest = testFactory.createBookstore(bookstoreDetails, false, true);

        Bookstore_Publisher__c bookstorePublisherForTest = testFactory.createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);

        Mocker BookstorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getListByBookstoreId', new List<Bookstore_Publisher__c>{bookstorePublisherForTest});

        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMock.getMock()
        );

        Mocker PublisherSelectorMock = new Mocker(PublisherSelector.class)
        .setBehavior('getPublishersNotInSet', new List<Publisher__c>{});
        
        ObjectFactory.mocks.put(
            PublisherSelector.class.getName(),
            (PublisherSelector) PublisherSelectorMock.getMock()
        );

        GetPublishersNotWithBookstoreService service = new GetPublishersNotWithBookstoreService();
        service.getPublishers(bookstoreForTest.Id);

        PublisherSelectorMock.assertMethodExecutionCount('getPublishersNotInSet', 1);
        BookstorePublisherSelectorMock.assertMethodExecutionCount('getListByBookstoreId', 1);
    }
}