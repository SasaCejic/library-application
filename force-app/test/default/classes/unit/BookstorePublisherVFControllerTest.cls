/**
 * Class tests selector execution account in BookstorePublisherVFController services
 * Every test requires data to be made so the controller can even be instantiated
 * Every test will require mocking the ReturnBookstorePublisherById class, because it runs in the constructor
 * Controller must be instantaiated because it is an extension of standard controller
 */
@isTest
public with sharing class BookstorePublisherVFControllerTest {
    /**
     * This method tests both if the delete failed, and the page reference that was returned.
     * If the deletion failed page reference will be null (staying on the same page of VF page)
     */
    @isTest
    public static void deleteRecord_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        ApexPages.StandardController stdController = new ApexPages.StandardController(bookstorePublisherForTest);
        Database.DeleteResult deleteResultForMock = (Database.DeleteResult) JSON.deserialize('{"success":true,"id":"0013000000abcde"}', Database.DeleteResult.class);

        // create mocks
        Mocker BookstorePublisherSelectorMocker = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getRecordById', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMocker.getMock()
        );

        Mocker DeleteBookPublisherRecordServiceMocker = new Mocker(DeleteBookPublisherRecordService.class);
        DeleteBookPublisherRecordServiceMocker.setBehavior('deleteBookstorePublisher', null);
        DeleteBookPublisherRecordServiceMocker.setBehavior('getResponse', deleteResultForMock);
        ObjectFactory.mocks.put(
            DeleteBookPublisherRecordService.class.getName(),
            (DeleteBookPublisherRecordService) DeleteBookPublisherRecordServiceMocker.getMock()
        );

        // execute
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        controller.deleteRecord();

        // assert 
        DeleteBookPublisherRecordServiceMocker.assertMethodExecutionCount('deleteBookstorePublisher', 1);
        DeleteBookPublisherRecordServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }

    @isTest
    public static void getBookstoreBooksCausingError_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        ApexPages.StandardController stdController = new ApexPages.StandardController(bookstorePublisherForTest);

        // create mocks
        Mocker BookstorePublisherSelectorMocker = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getRecordById', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMocker.getMock()
        );

        Mocker GetBokstoreBooksOnPublsherDeleteServiceMocker = new Mocker(GetBookstoreBookOnPublsherDeleteService.class);
        GetBokstoreBooksOnPublsherDeleteServiceMocker.setBehavior('getBookstoreBooks', null);
        GetBokstoreBooksOnPublsherDeleteServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            GetBookstoreBookOnPublsherDeleteService.class.getName(),
            (GetBookstoreBookOnPublsherDeleteService) GetBokstoreBooksOnPublsherDeleteServiceMocker.getMock()
        );

        // execute
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        controller.getBookstoreBooksCausingError();

        // assert 
        GetBokstoreBooksOnPublsherDeleteServiceMocker.assertMethodExecutionCount('getBookstoreBooks', 1);
        GetBokstoreBooksOnPublsherDeleteServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }

    @isTest
    public static void getPageReference_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        ApexPages.StandardController stdController = new ApexPages.StandardController(bookstorePublisherForTest);

        // create mocks
        Mocker BookstorePublisherSelectorMocker = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getRecordById', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMocker.getMock()
        );

        Mocker PageReferenceServiceMocker = new Mocker(PageReferenceService.class);
        PageReferenceServiceMocker.setBehavior('getPageReferenceForBookstorePublisher', null);
        PageReferenceServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            PageReferenceService.class.getName(),
            (PageReferenceService) PageReferenceServiceMocker.getMock()
        );

        // execute
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        controller.getPageReference();

        // assert 
        PageReferenceServiceMocker.assertMethodExecutionCount('getPageReferenceForBookstorePublisher', 1);
        PageReferenceServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }

    @isTest
    public static void cancel_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        ApexPages.StandardController stdController = new ApexPages.StandardController(bookstorePublisherForTest);

        // create mocks
        Mocker BookstorePublisherSelectorMocker = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getRecordById', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMocker.getMock()
        );

        Mocker PageReferenceServiceMocker = new Mocker(PageReferenceService.class);
        PageReferenceServiceMocker.setBehavior('getPageReferenceForBookstorePublisher', null);
        PageReferenceServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            PageReferenceService.class.getName(),
            (PageReferenceService) PageReferenceServiceMocker.getMock()
        );

        // execute
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        controller.cancel();
        PageReferenceServiceMocker.assertMethodExecutionCount('getPageReferenceForBookstorePublisher', 1);
        PageReferenceServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }

    @isTest
    public static void viewAll_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        ApexPages.StandardController stdController = new ApexPages.StandardController(bookstorePublisherForTest);

        // create mocks
        Mocker BookstorePublisherSelectorMocker = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getRecordById', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMocker.getMock()
        );

        Mocker PageReferenceServiceMocker = new Mocker(PageReferenceService.class);
        PageReferenceServiceMocker.setBehavior('getPageReferenceForBookstorePublisher', null);
        PageReferenceServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            PageReferenceService.class.getName(),
            (PageReferenceService) PageReferenceServiceMocker.getMock()
        );

        // execute
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        controller.viewAll();
        PageReferenceServiceMocker.assertMethodExecutionCount('getPageReferenceForBookstorePublisher', 1);
        PageReferenceServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }
}