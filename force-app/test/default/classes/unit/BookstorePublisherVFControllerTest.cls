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

        // create mocks
        Mocker ReturnBookstorePublisherBasedOnIdServiceMocker = new Mocker(ReturnBookstorePublisherBasedOnIdService.class);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('returnBookstorePublisher', null);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('getResponse', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            ReturnBookstorePublisherBasedOnIdService.class.getName(),
            (ReturnBookstorePublisherBasedOnIdService) ReturnBookstorePublisherBasedOnIdServiceMocker.getMock()
        );

        Mocker DeleteBookPublisherRecordServiceMocker = new Mocker(DeleteBookPublisherRecordService.class);
        DeleteBookPublisherRecordServiceMocker.setBehavior('deleteBookstorePublisher', null);
        DeleteBookPublisherRecordServiceMocker.setBehavior('getResponse', null);
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
        Mocker ReturnBookstorePublisherBasedOnIdServiceMocker = new Mocker(ReturnBookstorePublisherBasedOnIdService.class);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('returnBookstorePublisher', null);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('getResponse', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            ReturnBookstorePublisherBasedOnIdService.class.getName(),
            (ReturnBookstorePublisherBasedOnIdService) ReturnBookstorePublisherBasedOnIdServiceMocker.getMock()
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
        Mocker ReturnBookstorePublisherBasedOnIdServiceMocker = new Mocker(ReturnBookstorePublisherBasedOnIdService.class);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('returnBookstorePublisher', null);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('getResponse', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            ReturnBookstorePublisherBasedOnIdService.class.getName(),
            (ReturnBookstorePublisherBasedOnIdService) ReturnBookstorePublisherBasedOnIdServiceMocker.getMock()
        );

        Mocker GetPageReferenceForBookstorePublisherMocker = new Mocker(GetPageReferenceForBookstorePublisher.class);
        GetPageReferenceForBookstorePublisherMocker.setBehavior('getPageReference', null);
        GetPageReferenceForBookstorePublisherMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            GetPageReferenceForBookstorePublisher.class.getName(),
            (GetPageReferenceForBookstorePublisher) GetPageReferenceForBookstorePublisherMocker.getMock()
        );

        // execute
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        controller.getPageReference();

        // assert 
        GetPageReferenceForBookstorePublisherMocker.assertMethodExecutionCount('getPageReference', 1);
        GetPageReferenceForBookstorePublisherMocker.assertMethodExecutionCount('getResponse', 1);
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
        Mocker ReturnBookstorePublisherBasedOnIdServiceMocker = new Mocker(ReturnBookstorePublisherBasedOnIdService.class);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('returnBookstorePublisher', null);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('getResponse', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            ReturnBookstorePublisherBasedOnIdService.class.getName(),
            (ReturnBookstorePublisherBasedOnIdService) ReturnBookstorePublisherBasedOnIdServiceMocker.getMock()
        );

        Mocker GetPageReferenceForBookstorePublisherMocker = new Mocker(GetPageReferenceForBookstorePublisher.class);
        GetPageReferenceForBookstorePublisherMocker.setBehavior('getPageReference', null);
        GetPageReferenceForBookstorePublisherMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            GetPageReferenceForBookstorePublisher.class.getName(),
            (GetPageReferenceForBookstorePublisher) GetPageReferenceForBookstorePublisherMocker.getMock()
        );

        // execute
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        controller.cancel();
        GetPageReferenceForBookstorePublisherMocker.assertMethodExecutionCount('getPageReference', 1);
        GetPageReferenceForBookstorePublisherMocker.assertMethodExecutionCount('getResponse', 1);
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
        Mocker ReturnBookstorePublisherBasedOnIdServiceMocker = new Mocker(ReturnBookstorePublisherBasedOnIdService.class);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('returnBookstorePublisher', null);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('getResponse', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            ReturnBookstorePublisherBasedOnIdService.class.getName(),
            (ReturnBookstorePublisherBasedOnIdService) ReturnBookstorePublisherBasedOnIdServiceMocker.getMock()
        );

        Mocker GetPageReferenceForBookstorePublisherMocker = new Mocker(GetPageReferenceForBookstorePublisher.class);
        GetPageReferenceForBookstorePublisherMocker.setBehavior('getPageReference', null);
        GetPageReferenceForBookstorePublisherMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            GetPageReferenceForBookstorePublisher.class.getName(),
            (GetPageReferenceForBookstorePublisher) GetPageReferenceForBookstorePublisherMocker.getMock()
        );

        // execute
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        controller.viewAll();
        GetPageReferenceForBookstorePublisherMocker.assertMethodExecutionCount('getPageReference', 1);
        GetPageReferenceForBookstorePublisherMocker.assertMethodExecutionCount('getResponse', 1);
    }
}