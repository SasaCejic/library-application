/*
* Class used to perform unit tests for this service
* Class will perform 3 tests: 1 positive, 1 negative and one for asserting method execution count for mockers
*/
@isTest
public with sharing class GetBooksNotInBookstoreServiceTest {
    @isTest
    public static void getBooks_willReturnOneBook_ifNoBookstoreBookRecordsAreCreated() {
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
    
        //Mock BookstoreBook selector so we don't depend on it
        Mocker BookstoreBookSelectorMock = new Mocker(BookstoreBookSelector.class)
        .setBehavior('getListByBookstoreId', new List<Bookstore_Book__c>());
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector)BookstoreBookSelectorMock.getMock()
        );
        //Mock Book selector
        Mocker BookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBooksNotInSet', new List<Book__c>{bookForTest});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)BookSelectorMock.getMock()
        );

        GetBooksNotInBookstoreService service = new GetBooksNotInBookstoreService();
        service.getBooks(bookstoreForTest.Id);
        List<Book__c> booksNotInBookstore = service.getResponse();

        System.assertEquals(1, booksNotInBookstore.size());
    }

    @isTest
    public static void getBooks_willNotReturnAnyBooks_ifBookstoreBookRecordIsCreated() {
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

        //Mock BookstoreBook selector so we don't depend on it
        Mocker BookstoreBookSelectorMock = new Mocker(BookstoreBookSelector.class)
        .setBehavior('getListByBookstoreId', new List<Bookstore_Book__c>{bookstoreBookForTest});
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector)BookstoreBookSelectorMock.getMock()
        );
        //Mock Book selector
        Mocker BookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBooksNotInSet', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)BookSelectorMock.getMock()
        );

        GetBooksNotInBookstoreService service = new GetBooksNotInBookstoreService();
        service.getBooks(bookstoreForTest.Id);
        List<Book__c> booksNotInBookstore = service.getResponse();

        System.assertEquals(0, booksNotInBookstore.size());
    }

    @isTest
    public static void getBooks_willUseCorrectSelectors() {
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

        //Mock BookstoreBook selector so we don't depend on it
        Mocker BookstoreBookSelectorMock = new Mocker(BookstoreBookSelector.class)
        .setBehavior('getListByBookstoreId', new List<Bookstore_Book__c>{bookstoreBookForTest});
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector)BookstoreBookSelectorMock.getMock()
        );
        //Mock Book selector
        Mocker BookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBooksNotInSet', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)BookSelectorMock.getMock()
        );

        GetBooksNotInBookstoreService service = new GetBooksNotInBookstoreService();
        service.getBooks(bookstoreForTest.Id);
        List<Book__c> booksNotInBookstore = service.getResponse();

        BookSelectorMock.assertMethodExecutionCount('getBooksNotInSet', 1);
        BookstoreBookSelectorMock.assertMethodExecutionCount('getListByBookstoreId', 1);
    }
}