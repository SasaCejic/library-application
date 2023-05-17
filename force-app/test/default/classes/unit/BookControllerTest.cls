/*
 * Class that performs unit tests for book controller
 */
@isTest
public with sharing class BookControllerTest {
    @isTest
    public static void getBooksNotInBookstore_willUseService() {
        // create mock
        Mocker getBooksNotInBookstoreServiceMock = new Mocker(getBooksNotInBookstoreService.class)
        .setBehavior('getBooks', null);
        getBooksNotInBookstoreServiceMock.setBehavior('getResponse', new List<Book__c>{});
        getBooksNotInBookstoreServiceMock.setBehavior('getBooks', null);
        ObjectFactory.mocks.put(
            GetBooksNotInBookstoreService.class.getName(),
            (GetBooksNotInBookstoreService) getBooksNotInBookstoreServiceMock.getMock()
        );

        // execute
        List<Book__c> booksNotInBookstore = BookController.getBooksNotInBookstore(new TestFactory().getFakeId(Bookstore__c.SObjectType, true), 5);

        // assert
        getBooksNotInBookstoreServiceMock.assertMethodExecutionCount('getBooks', 1);
        getBooksNotInBookstoreServiceMock.assertMethodExecutionCount('getResponse', 1);
    }

    @isTest
    public static void getBookById_willUseService() {
        // create mock
        Mocker bookserviceMock = new Mocker(BookService.class)
        .setBehavior('getBookById', null);
        bookserviceMock.setBehavior('getResponse', new Book__c());

        ObjectFactory.mocks.put(
            BookService.class.getName(),
            (BookService) bookserviceMock.getMock()
        );

        // execute
        Book__c book = BookController.getBookById(new TestFactory().getFakeId(Book__c.SObjectType, true));

        // assert
        bookserviceMock.assertMethodExecutionCount('getBookById', 1);
        bookserviceMock.assertMethodExecutionCount('getResponse', 1);
    }
}