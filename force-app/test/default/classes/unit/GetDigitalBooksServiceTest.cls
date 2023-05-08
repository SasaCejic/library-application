/*
 * Class used for testing GetDigitalBooksService, will perform 1 positive, 1 negative and 1 method execution test
 */
@isTest
public with sharing class GetDigitalBooksServiceTest {
    @isTest
    public static void getBooks_willReturnOneBook_ifOneDigitalBookIsCreated() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createDigitalBook(publisherForTest.Id, authorForTest.Id, false, true);
        
        // create mock
        Mocker BookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getDigitalBooksList', new List<Book__c>{bookForTest});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)BookSelectorMock.getMock()
        );

        // execute
        GetDigitalBooksService service = new GetDigitalBooksService();
        service.getBooks('');
        List<Book__c> booksNotInBookstore = service.getResponse();

        // assert
        Assert.areEqual(1, booksNotInBookstore.size());
    }

    @isTest
    public static void getBooks_willNotReturnAnything_ifNoDigitalBooksWereCreated() {
        // create  mock
        Mocker BookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getDigitalBooksList', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)BookSelectorMock.getMock()
        );

        // execute
        GetDigitalBooksService service = new GetDigitalBooksService();
        service.getBooks('');
        List<Book__c> booksNotInBookstore = service.getResponse();

        // assert
        Assert.areEqual(0, booksNotInBookstore.size());
    }

    @isTest
    public static void getBooks_willUseCorrectSelector() {
        // create  mock
        Mocker BookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getDigitalBooksList', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)BookSelectorMock.getMock()
        );

        // execute
        GetDigitalBooksService service = new GetDigitalBooksService();
        service.getBooks('');
        List<Book__c> booksNotInBookstore = service.getResponse();

        // assert
        BookSelectorMock.assertMethodExecutionCount('getDigitalBooksList', 1);
    }
}