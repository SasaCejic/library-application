/*
* This class is used to test logic in BookstoreBookTriggerHandler
*/
@isTest
public with sharing class BookstoreBookTriggerHandlerTest {
    @isTest
    public static void beforeInsert_willNotFindError_ifErrorNotAdded() {
        //Create data for mocks and test
        List<Publisher__c> publisherForTest = new TestFactory().createPublishers(1);
        insert publisherForTest;
        List<Bookstore__c> bookstoreForTest = new TestFactory().createBookstores(1);
        insert bookstoreForTest;
        List<Book__c> bookForTest = new TestFactory().createBooks(1, publisherForTest[0].Id);
        insert bookForTest;
        List<Bookstore_Book__c> bookstoreBooksForMock = new TestFactory()
        .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);

        Mocker bookstoreBookValidationServiceMock = new Mocker(BookstoreBookValidationService.class)
        .setBehavior('validatePublisher', bookstoreBooksForMock);
        ObjectFactory.mocks.put(
            BookstoreBookValidationService.class.getName(),
            (BookstoreBookValidationService)bookstoreBookValidationServiceMock.getMock()
        );

        Test.startTest();
        BookstoreBookTriggerHandler bookstoreBookTriggerHandler = new BookstoreBookTriggerHandler();
        bookstoreBookTriggerHandler.beforeInsert(bookstoreBooksForMock);
        Test.stopTest();

        System.assert(bookstoreBooksForMock[0].getErrors().size() == 0);
    }
    @isTest
    public static void beforeInsert_willNotPerformValidation_whenTriggerHandlerDisabled() {
        //Create data for mocks and test
        List<Publisher__c> publisherForTest = new TestFactory().createPublishers(1);
        insert publisherForTest;
        List<Bookstore__c> bookstoreForTest = new TestFactory().createBookstores(1);
        insert bookstoreForTest;
        List<Book__c> bookForTest = new TestFactory().createBooks(1, publisherForTest[0].Id);
        insert bookForTest;
        List<Bookstore_Book__c> bookstoreBooksForMock = new TestFactory()
        .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);

        Mocker bookstoreBookValidationServiceMock = new Mocker(BookstoreBookValidationService.class)
        .setBehavior('validatePublisher', bookstoreBooksForMock);
        ObjectFactory.mocks.put(
            BookstoreBookValidationService.class.getName(),
            (BookstoreBookValidationService)bookstoreBookValidationServiceMock.getMock()
        );

        Test.startTest();
        BookstoreBookTriggerHandler bookstoreBookTriggerHandler = new BookstoreBookTriggerHandler();
        bookstoreBookTriggerHandler.disableTrigger();
        bookstoreBookTriggerHandler.beforeInsert(bookstoreBooksForMock);
        Test.stopTest();

        bookstoreBookValidationServiceMock.assertMethodExecutionCount('validatePublisher', 0);
    }
    @isTest
    public static void beforeInsert_willTestMethodExecutionCount_ifTriggerIsNotDisabled() {
        //Create data for mocks and test
        List<Publisher__c> publisherForTest = new TestFactory().createPublishers(1);
        insert publisherForTest;
        List<Bookstore__c> bookstoreForTest = new TestFactory().createBookstores(1);
        insert bookstoreForTest;
        List<Book__c> bookForTest = new TestFactory().createBooks(1, publisherForTest[0].Id);
        insert bookForTest;
        List<Bookstore_Book__c> bookstoreBooksForMock = new TestFactory()
        .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);

        Mocker bookstoreBookValidationServiceMock = new Mocker(BookstoreBookValidationService.class)
        .setBehavior('validatePublisher', bookstoreBooksForMock);
        ObjectFactory.mocks.put(
            BookstoreBookValidationService.class.getName(),
            (BookstoreBookValidationService)bookstoreBookValidationServiceMock.getMock()
        );

        Test.startTest();
        BookstoreBookTriggerHandler bookstoreBookTriggerHandler = new BookstoreBookTriggerHandler();
        bookstoreBookTriggerHandler.beforeInsert(bookstoreBooksForMock);
        Test.stopTest();

        bookstoreBookValidationServiceMock.assertMethodExecutionCount('validatePublisher', 1);
    }
}