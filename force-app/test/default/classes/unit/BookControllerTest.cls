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
}