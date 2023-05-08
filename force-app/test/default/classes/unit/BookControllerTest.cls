/*
 * Class that performs unit tests for book controller
 */
@isTest
public with sharing class BookControllerTest {
    @isTest
    public static void getBooksNotInBookstore_willUseService() {
        // create mock
        Mocker getBooksNotInBookstoreServiceMock = new Mocker(getBooksNotInBookstoreService.class);
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
    public static void getDigitalBooks_willUseService() {
        // create mock
        Mocker getDigitalBooksServiceMock = new Mocker(GetDigitalBooksService.class);
        getDigitalBooksServiceMock.setBehavior('getResponse', new List<Book__c>{});
        getDigitalBooksServiceMock.setBehavior('getBooks', null);
        ObjectFactory.mocks.put(
            GetDigitalBooksService.class.getName(),
            (GetDigitalBooksService) getDigitalBooksServiceMock.getMock()
        );

        // execute
        List<Book__c> digitalBooks = BookController.getDigitalBooks('');

        // assert
        getDigitalBooksServiceMock.assertMethodExecutionCount('getBooks', 1);
        getDigitalBooksServiceMock.assertMethodExecutionCount('getResponse', 1);
    }
}