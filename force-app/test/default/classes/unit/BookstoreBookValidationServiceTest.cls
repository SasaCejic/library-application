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

        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('firstName', 'Author');
        authorDetails.put('lastName', 'Author');
        Author__c authorForTest = testFactory.createAuthor(authorDetails, false, true);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);

        Bookstore_Book__c bookstoreBookForTest = testFactory
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false, true);
        Bookstore_Publisher__c bookStorePublisherForMock = testFactory
        .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        
        Map<Id, Book__c> bookMapForMock = new Map<Id, Book__c>();
        bookMapForMock.put(bookForTest.Id, bookForTest);
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getMapByIds', bookMapForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getList', new List<Bookstore_Publisher__c>{bookStorePublisherForMock});
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );

        BookstoreBookValidationService bookStoreBookValidation = new BookstoreBookValidationService();
        bookStoreBookValidation.validatePublisher(new List<Bookstore_Book__c>{bookstoreBookForTest});

        System.assert(bookstoreBookForTest.getErrors().size() == 0);
    }
    
    @isTest
    public static void validatePublisher_willAddError_ifBookstorePublisherIsNotAdded() {
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

       Map<String, String> authorDetails = new Map<String, String>();
       authorDetails.put('firstName', 'Author');
       authorDetails.put('lastName', 'Author');
       Author__c authorForTest = testFactory.createAuthor(authorDetails, true, false);

       Map<String, String> bookDetails = new Map<String, String>();
       bookDetails.put('name', 'book');
       bookDetails.put('description', 'bookdesc');
       bookDetails.put('ISBN', '214215425');
       bookDetails.put('language', 'english');
       bookDetails.put('categories', 'fantasy');
       Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);

       Bookstore_Book__c bookstoreBookForTest = testFactory
       .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false, true);
       
       Map<Id, Book__c> bookMapForMock = new Map<Id, Book__c>();
       bookMapForMock.put(bookForTest.Id, bookForTest);
       //Mock book selector so we don't depend on it
       Mocker bookSelectorMock = new Mocker(BookSelector.class)
       .setBehavior('getMapByIds', bookMapForMock);
       ObjectFactory.mocks.put(
           BookSelector.class.getName(),
           (BookSelector)bookSelectorMock.getMock()
       );
       //Mock BookstoreBook selector so we don't depend on it
       Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
       .setBehavior('getList', new List<Bookstore_Publisher__c>());
       ObjectFactory.mocks.put(
           BookstorePublisherSelector.class.getName(),
           (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
       );

       BookstoreBookValidationService bookStoreBookValidation = new BookstoreBookValidationService();
       bookStoreBookValidation.validatePublisher(new List<Bookstore_Book__c>{bookstoreBookForTest});

       System.assert(bookstoreBookForTest.getErrors().size() == 1);
    }
    
    @isTest
    public static void validatePublisher_willUseCorrectSelectors() {
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

        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('firstName', 'Author');
        authorDetails.put('lastName', 'Author');
        Author__c authorForTest = testFactory.createAuthor(authorDetails, true, false);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);

        Bookstore_Book__c bookstoreBookForTest = testFactory
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false, true);
        
        Map<Id, Book__c> bookMapForMock = new Map<Id, Book__c>();
        bookMapForMock.put(bookForTest.Id, bookForTest);
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getMapByIds', bookMapForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getList', new List<Bookstore_Publisher__c>());
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );

        BookstoreBookValidationService bookStoreBookValidation = new BookstoreBookValidationService();
        bookStoreBookValidation.validatePublisher(new List<Bookstore_Book__c>{bookstoreBookForTest});
        
        bookSelectorMock.assertMethodExecutionCount('getMapByIds', 1);
        bookStorePublisherSelectorMock.assertMethodExecutionCount('getList', 1);
    }
}