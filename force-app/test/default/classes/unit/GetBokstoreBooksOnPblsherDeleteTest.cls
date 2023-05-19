/**
 * Class used for testing GetBookstoreBooksOnPublihserDeleteService
 */
@isTest
public with sharing class GetBokstoreBooksOnPblsherDeleteTest {
    @isTest
    public static void getBookstoreBooks_willNotAddError_ifBookstoreBookWithSamePublisherDoesentExists() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);

        // create mock
        Mocker BookstorePublisherSelectorMocker = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getRecordById', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMocker.getMock()
        );

        Mocker BookstoreBookSelectorMocker = new Mocker(BookstoreBookSelector.class)
            .setBehavior('getListByBookstoreId', new List<Bookstore_Book__c>{});
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector) BookstoreBookSelectorMocker.getMock()
        );

        // execute
        GetBokstoreBooksOnPublsherDeleteService service = new GetBokstoreBooksOnPublsherDeleteService();
        service.getBookstoreBooks(bookstorePublisherForTest.Id, 5);

        // Assert
        Assert.isTrue(bookstorePublisherForTest.getErrors().size() == 0);
    }

    @isTest
    public static void getBookstoreBooks_willUseSelectors() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);

        // create mock
        Mocker BookstorePublisherSelectorMocker = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getRecordById', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMocker.getMock()
        );

        Mocker BookstoreBookSelectorMocker = new Mocker(BookstoreBookSelector.class)
            .setBehavior('getListByBookstoreId', new List<Bookstore_Book__c>{});
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector) BookstoreBookSelectorMocker.getMock()
        );

        // execute
        GetBokstoreBooksOnPublsherDeleteService service = new GetBokstoreBooksOnPublsherDeleteService();
        service.getBookstoreBooks(bookstorePublisherForTest.Id, 5);

        // Assert
        BookstorePublisherSelectorMocker.assertMethodExecutionCount('getRecordById', 1);
        BookstoreBookSelectorMocker.assertMethodExecutionCount('getListByBookstoreId', 1);
    }
}