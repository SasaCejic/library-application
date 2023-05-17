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
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
        Bookstore_Book__c bookstoreBookForTest = testFactory
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false, true);
        Bookstore_Publisher__c bookStorePublisherForMock = testFactory
        .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);

        // create mocks
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getMapByIds', new Map<Id, Book__c>{
                bookForTest.Id => bookForTest
        });
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getList', new List<Bookstore_Publisher__c>{bookStorePublisherForMock});
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );

        // execute
        BookstoreBookValidationService bookStoreBookValidation = new BookstoreBookValidationService();
        bookStoreBookValidation.validatePublisher(new List<Bookstore_Book__c>{bookstoreBookForTest});

        // assert
        Assert.isTrue(bookstoreBookForTest.getErrors().size() == 0);
    }
    
    @isTest
    public static void validatePublisher_willAddError_ifBookstorePublisherIsNotAdded() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
        Bookstore_Book__c bookstoreBookForTest = testFactory
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false, true);
        
        // create mocks
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getMapByIds', new Map<Id, Book__c>{
                bookForTest.Id => bookForTest
        });
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getList', new List<Bookstore_Publisher__c>());
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );

        // execute
        BookstoreBookValidationService bookStoreBookValidation = new BookstoreBookValidationService();
        bookStoreBookValidation.validatePublisher(new List<Bookstore_Book__c>{bookstoreBookForTest});

        // assert
        Assert.isTrue(bookstoreBookForTest.getErrors().size() == 1);
    }
    
    @isTest
    public static void validatePublisher_willUseCorrectSelectors() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
        Bookstore_Book__c bookstoreBookForTest = testFactory
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false, true);
        
        // create mocks
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getMapByIds', new Map<Id, Book__c>{
            bookForTest.Id => bookForTest
        });
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getList', new List<Bookstore_Publisher__c>());
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );

        // execute
        BookstoreBookValidationService bookStoreBookValidation = new BookstoreBookValidationService();
        bookStoreBookValidation.validatePublisher(new List<Bookstore_Book__c>{bookstoreBookForTest});
        
        // assert
        bookSelectorMock.assertMethodExecutionCount('getMapByIds', 1);
        bookStorePublisherSelectorMock.assertMethodExecutionCount('getList', 1);
    }
}