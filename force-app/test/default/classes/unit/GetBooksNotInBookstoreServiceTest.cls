/*
* Class used to perform unit tests for this service
* Class will perform 3 tests: 1 positive, 1 negative and one for asserting method execution count for mockers
*/
@isTest
public with sharing class GetBooksNotInBookstoreServiceTest {
    @isTest
    public static void getBooks_willReturnOneBook_ifNoBookstoreBookRecordsAreCreated() {
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
    
        //Mock BookstoreBook selector so we don't depend on it
        Mocker BookstoreBookSelectorMock = new Mocker(BookstoreBookSelector.class)
        .setBehavior('getListByBookstoreId', new List<Bookstore_Book__c>());
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector)BookstoreBookSelectorMock.getMock()
        );
        //Mock Book selector
        Mocker BookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getListNotInIds', new List<Book__c>{bookForTest});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)BookSelectorMock.getMock()
        );

        GetBooksNotInBookstoreService service = new GetBooksNotInBookstoreService();
        service.getBooks(bookstoreForTest.Id);
        List<Book__c> booksNotInBookstore = service.getResponse();

        Assert.areEqual(1, booksNotInBookstore.size());
    }

    @isTest
    public static void getBooks_willNotReturnAnyBooks_ifBookstoreBookRecordIsCreated() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
    
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
        .setBehavior('getListNotInIds', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)BookSelectorMock.getMock()
        );

        GetBooksNotInBookstoreService service = new GetBooksNotInBookstoreService();
        service.getBooks(bookstoreForTest.Id);
        List<Book__c> booksNotInBookstore = service.getResponse();

        Assert.areEqual(0, booksNotInBookstore.size());
    }

    @isTest
    public static void getBooks_willUseCorrectSelectors() {
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
    
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
        .setBehavior('getListNotInIds', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)BookSelectorMock.getMock()
        );

        GetBooksNotInBookstoreService service = new GetBooksNotInBookstoreService();
        service.getBooks(bookstoreForTest.Id);
        List<Book__c> booksNotInBookstore = service.getResponse();

        BookSelectorMock.assertMethodExecutionCount('getListNotInIds', 1);
        BookstoreBookSelectorMock.assertMethodExecutionCount('getListByBookstoreId', 1);
    }
}