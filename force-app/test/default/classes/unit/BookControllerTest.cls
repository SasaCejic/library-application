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
    public static void getBookById_willUseSelector() {
        // create mock
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getBookById', new Book__c());
        // set mock
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMock.getMock()
        );


        // execute
        Book__c book = BookController.getBookById(new TestFactory().getFakeId(Book__c.SObjectType, true));

        // assert
        bookSelectorMock.assertMethodExecutionCount('getBookById', 1);
    }

    @isTest
    public static void confirmDigitalBookPurchase_willUseServices() {
        // create mock data
        TestFactory testFactory = new TestFactory();
        Id testId = testFactory.getFakeId(Book_Purchase__c.SObjectType, true);
        Database.SaveResult saveResultForMock = (Database.SaveResult) JSON.deserialize('{"success":true,"id":"0013000000abcde"}', Database.SaveResult.class);

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
        bookSearchServiceMock.setBehavior('getResponse', new BookSearchResultDTO());
        bookSearchServiceMock.setBehavior('getBooksFromSearchDTO', new BookSearchResultDTO());
        ObjectFactory.mocks.put(
            BookSearchService.class.getName(),
            (BookSearchService) bookSearchServiceMock.getMock()
        );

        // execute
        BookController.getBooksFromSearchDTO(new BookSearchDTO(), 5, 5);

        // assert
        bookSearchServiceMock.assertMethodExecutionCount('getBooksFromSearchDTO', 1);
        bookSearchServiceMock.assertMethodExecutionCount('getResponse', 1);
    }

    @isTest
    public static void returnBooksCausingErrorOnAuthPubDel_willUseService() {
        // create mock data
        TestFactory testFactory = new TestFactory();
        Id testId = testFactory.getFakeId(Author__c.SObjectType, true);

        // create mock
        Mocker getRelatedBooksOnAuthPubDelServiceMock = new Mocker(GetRelatedBooksOnAuthPubDelService.class);
        getRelatedBooksOnAuthPubDelServiceMock.setBehavior('getResponse', null);
        getRelatedBooksOnAuthPubDelServiceMock.setBehavior('getRelatedBooks', null);
        ObjectFactory.mocks.put(
            GetRelatedBooksOnAuthPubDelService.class.getName(),
            (GetRelatedBooksOnAuthPubDelService) getRelatedBooksOnAuthPubDelServiceMock.getMock()
        );

        // execute
        BookController.returnBooksCausingErrorOnAuthPubDel(testId, 5);

        // assert
        getRelatedBooksOnAuthPubDelServiceMock.assertMethodExecutionCount('getRelatedBooks', 1);
        getRelatedBooksOnAuthPubDelServiceMock.assertMethodExecutionCount('getResponse', 1);
    }
}