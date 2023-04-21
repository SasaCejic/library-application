/*
*This class performs unit tests for BookstoreBookValidationService class
*Tests consist of 2 mocks where we mock selectors
*Both single and multiple validations are tested
*Method Execution count will always be the same regardless of the amount of records inserted
*/
@isTest
public with sharing class BookstoreBookValidationServiceTest {
    @isTest
    public static void validatePublisher_willNotAddError_ifBookstorePublisherIsAdded() {
        //Create data for mocks and test
        List<Publisher__c> publisherForTest = new TestFactory().createPublishers(1);
        insert publisherForTest;
        List<Bookstore__c> bookstoreForTest = new TestFactory().createBookstores(1);
        insert bookstoreForTest;
        List<Book__c> bookForTest = new TestFactory().createBooks(1, publisherForTest[0].Id);
        insert bookForTest;
        List<Bookstore_Book__c> bookstoreBooksForTest = new TestFactory()
        .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);
        List<Bookstore_Publisher__c> bookStorePublisherForMock = new TestFactory()
        .createBookstorePublishers(1, publisherForTest[0].Id, bookstoreForTest[0].Id);
        Map<Id, Book__c> bookMapForMock = new Map<Id, Book__c>();
        bookMapForMock.put(bookForTest[0].Id, bookForTest[0]);
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBooksBySetOfIds', bookMapForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getAllBookstorePublishers', bookStorePublisherForMock);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );

        Test.startTest();
        BookstoreBookValidationService bookStoreBookValidation = new BookstoreBookValidationService();
        bookStoreBookValidation.validatePublisher(bookstoreBooksForTest);
        Test.stopTest();

        System.assert(bookstoreBooksForTest[0].getErrors().size() == 0);
    }
    @isTest
    public static void validatePublisher_willAddError_ifBookstorePublisherIsNotAdded() {
        //Create data for mocks and test
        List<Publisher__c> publisherForTest = new TestFactory().createPublishers(1);
        insert publisherForTest;
        List<Bookstore__c> bookstoreForTest = new TestFactory().createBookstores(1);
        insert bookstoreForTest;
        List<Book__c> bookForTest = new TestFactory().createBooks(1, publisherForTest[0].Id);
        insert bookForTest;
        List<Bookstore_Book__c> bookstoreBooksForTest = new TestFactory()
        .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);
        List<Bookstore_Publisher__c> bookStorePublisherForMock = new List<Bookstore_Publisher__c>();
        Map<Id, Book__c> bookMapForMock = new Map<Id, Book__c>();
        bookMapForMock.put(bookForTest[0].Id, bookForTest[0]);
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBooksBySetOfIds', bookMapForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getAllBookstorePublishers', bookStorePublisherForMock);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );

        Test.startTest();
        BookstoreBookValidationService bookStoreBookValidation = new BookstoreBookValidationService();
        bookStoreBookValidation.validatePublisher(bookstoreBooksForTest);
        Test.stopTest();

        System.assert(bookstoreBooksForTest[0].getErrors().size() > 0);
    }
    @isTest
    public static void validatePublisher_willAddMultipleErrors_ifBookstorePublishersAreNotAdded() {
        //Create data for mocks and test
        List<Publisher__c> publisherForTest = new TestFactory().createPublishers(1);
        insert publisherForTest;
        List<Bookstore__c> bookstoreForTest = new TestFactory().createBookstores(1);
        insert bookstoreForTest;
        List<Book__c> bookForTest = new TestFactory().createBooks(1, publisherForTest[0].Id);
        insert bookForTest;
        List<Bookstore_Book__c> bookstoreBooksForTest = new TestFactory()
        .createBookstoreBooks(5, bookForTest[0].Id, bookstoreForTest[0].Id);
        List<Bookstore_Publisher__c> bookStorePublisherForMock = new List<Bookstore_Publisher__c>();
        Map<Id, Book__c> bookMapForMock = new Map<Id, Book__c>();
        bookMapForMock.put(bookForTest[0].Id, bookForTest[0]);
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBooksBySetOfIds', bookMapForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getAllBookstorePublishers', bookStorePublisherForMock);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );

        Test.startTest();
        BookstoreBookValidationService bookStoreBookValidation = new BookstoreBookValidationService();
        bookStoreBookValidation.validatePublisher(bookstoreBooksForTest);
        Test.stopTest();
        for(Bookstore_Book__c bookstoreBookForTest:bookstoreBooksForTest) {
            System.assert(bookstoreBookForTest.getErrors().size() > 0);
        }
    }
    @isTest
    public static void validatePublisher_willTestMethodExecutionCount_ifFiveBookstoreBooksAreInserted() {
        //Create data for mocks and test
        List<Publisher__c> publisherForTest = new TestFactory().createPublishers(1);
        insert publisherForTest;
        List<Bookstore__c> bookstoreForTest = new TestFactory().createBookstores(1);
        insert bookstoreForTest;
        List<Book__c> bookForTest = new TestFactory().createBooks(5, publisherForTest[0].Id);
        insert bookForTest;
        List<Bookstore_Book__c> bookstoreBooksForTest = new TestFactory()
        .createBookstoreBooks(5, bookForTest[0].Id, bookstoreForTest[0].Id);
        List<Bookstore_Publisher__c> bookStorePublisherForMock = new List<Bookstore_Publisher__c>();
        Map<Id, Book__c> bookMapForMock = new Map<Id, Book__c>();
        bookMapForMock.put(bookForTest[0].Id, bookForTest[0]);
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBooksBySetOfIds', bookMapForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getAllBookstorePublishers', bookStorePublisherForMock);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );

        Test.startTest();
        BookstoreBookValidationService bookStoreBookValidation = new BookstoreBookValidationService();
        bookStoreBookValidation.validatePublisher(bookstoreBooksForTest);
        Test.stopTest();
        bookSelectorMock.assertMethodExecutionCount('getBooksBySetOfIds', 1);
        bookStorePublisherSelectorMock.assertMethodExecutionCount('getAllBookstorePublishers', 1);
    }
}