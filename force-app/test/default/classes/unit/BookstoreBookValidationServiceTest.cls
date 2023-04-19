/*
*This class performs unit tests for BookstoreBookValidationService class
*Tests consist of 2 mocks where we mock selectors
*Since these are unit tests, all the Ids used are dummy Ids, they just had to be 18 char long
in order for objects to be created in the first place.
*/
@isTest
public with sharing class BookstoreBookValidationServiceTest {
    @isTest
    public static void validatePublisher_validationSuccessfull() {
        //Create data for mocks and test
        List<Bookstore_Book__c> bookstoreBooksForTest = new TestFactory().
        createBookstoreBooks(1, 'a043N00000BRi9rQAD', 'a043N00000BRi9rQAD');
        List<Book__c> bookForMock = new TestFactory().createBooks(1, 'a043N00000BRi9rQAD');
        Map<Id, Book__c> bookMapForMock = new Map<Id, Book__c>();
        bookMapForMock.put('a043N00000BRi9rQAD', bookForMock[0]);
        List<Bookstore_Publisher__c> bkstorePublisherForMock = new TestFactory()
        .createBookstorePublishers(1, 'a043N00000BRi9rQAD', 'a043N00000BRi9rQAD');
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBooksBySetOfIds', bookMapForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getBookstorePublishersWithPublisherAndBookstoreId', bkstorePublisherForMock);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );

        Test.startTest();
        BookstoreBookValidationService bkStoreBookValidation = new BookstoreBookValidationService();
        bkStoreBookValidation.validatePublisher(bookstoreBooksForTest);
        Test.stopTest();

        System.assert(bookstoreBooksForTest[0].getErrors().size() == 0);
        bookSelectorMock.assertMethodExecutionCount('getBooksBySetOfIds', 1);
        bookStorePublisherSelectorMock
        .assertMethodExecutionCount('getBookstorePublishersWithPublisherAndBookstoreId', 1);
    }
    
    @isTest
    public static void validatePublisher_validationFailure() {
        //Create data for mocks and test
        List<Bookstore_Book__c> bookstoreBooksForTest = new TestFactory().
        createBookstoreBooks(1, 'a043N00000BRi9rQAD', 'a043N00000BRi9rQAD');
        List<Book__c> bookForMock = new TestFactory().createBooks(1, 'a043N00000BRi9rQAD');
        Map<Id, Book__c> bookMapForMock = new Map<Id, Book__c>();
        bookMapForMock.put('a043N00000BRi9rQAD', bookForMock[0]);
        List<Bookstore_Publisher__c> bkstorePublisherForMock = new List<Bookstore_Publisher__c>();
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBooksBySetOfIds', bookMapForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getBookstorePublishersWithPublisherAndBookstoreId', bkstorePublisherForMock);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );
       
        Test.startTest();
        BookstoreBookValidationService bkStoreBookValidation = new BookstoreBookValidationService();
        bkStoreBookValidation.validatePublisher(bookstoreBooksForTest);
        Test.stopTest();
        System.assert(bookstoreBooksForTest[0].getErrors().size() > 0);
        bookSelectorMock.assertMethodExecutionCount('getBooksBySetOfIds', 1);
        bookStorePublisherSelectorMock.assertMethodExecutionCount('getBookstorePublishersWithPublisherAndBookstoreId', 1);
    }
}