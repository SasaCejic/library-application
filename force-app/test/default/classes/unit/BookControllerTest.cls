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
    public static void confirmDigitalBookPurchase_willUseServices() {
        // create mock data
        TestFactory testFactory = new TestFactory();
        Id testId = testFactory.getFakeId(Book_Purchase__c.SObjectType, true);
        Database.SaveResult saveResultForMock = testFactory.createSuccessDatabaseSaveResult();

        // create mocks
        Mocker insertBookPurchaseServiceMock = new Mocker(InsertBookPurchaseRecordService.class);
        insertBookPurchaseServiceMock.setBehavior('getResponse', saveResultForMock);
        insertBookPurchaseServiceMock.setBehavior('insertPurchase', null);
        ObjectFactory.mocks.put(
            InsertBookPurchaseRecordService.class.getName(),
            (InsertBookPurchaseRecordService) insertBookPurchaseServiceMock.getMock()  
        );
        Mocker sendPurchaseEmailConfirmationServiceMock = new Mocker(SendPurchaseEmailConfirmationService.class);
        sendPurchaseEmailConfirmationServiceMock.setBehavior('getResponse', null);
        sendPurchaseEmailConfirmationServiceMock.setBehavior('sendMail', null);
        ObjectFactory.mocks.put(
            SendPurchaseEmailConfirmationService.class.getName(),
            (SendPurchaseEmailConfirmationService) SendPurchaseEmailConfirmationServiceMock.getMock()  
        );

        // execute
        BookController.confirmDigitalBookPurchase('testAddress', 'testName', 'testPrice', testId);

        // assert
        insertBookPurchaseServiceMock.assertMethodExecutionCount('getResponse', 1);
        insertBookPurchaseServiceMock.assertMethodExecutionCount('insertPurchase', 1);
        sendPurchaseEmailConfirmationServiceMock.assertMethodExecutionCount('sendMail', 1);
    }

    @isTest
    public static void getBooksFromSearchDTO_willUseService() {
        // create mock
        Mocker bookSearchServiceMock = new Mocker(BookSearchService.class);
        bookSearchServiceMock.setBehavior('getResponse', new List<Book__c>{});
        bookSearchServiceMock.setBehavior('getBooksFromSearchDTO', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSearchService.class.getName(),
            (BookSearchService) bookSearchServiceMock.getMock()
        );

        // execute
        List<Book__c> searchedBooks = BookController.getBooksFromSearchDTO(new BookSearchDTO(), 5, 5);

        // assert
        bookSearchServiceMock.assertMethodExecutionCount('getBooksFromSearchDTO', 1);
        bookSearchServiceMock.assertMethodExecutionCount('getResponse', 1);
    }
}