/**
 * Class tests selector execution account in BookstorePublisherController services
 * Every test requires data to be made so the controller can even be instantiated
 * Every test will require mocking the ReturnBookstorePublisherById class, because it runs in the constructor
 * Controller must be instantaiated because it is an extension of standard controller
 */
@isTest
public with sharing class BookstorePublisherControllerTest {
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
        BookstorePublisherController controller = new BookstorePublisherController(stdController);
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

        Mocker GetBokstoreBooksOnPublsherDeleteServiceMocker = new Mocker(GetBokstoreBooksOnPublsherDeleteService.class);
        GetBokstoreBooksOnPublsherDeleteServiceMocker.setBehavior('getBookstoreBooks', null);
        GetBokstoreBooksOnPublsherDeleteServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            GetBokstoreBooksOnPublsherDeleteService.class.getName(),
            (GetBokstoreBooksOnPublsherDeleteService) GetBokstoreBooksOnPublsherDeleteServiceMocker.getMock()
        );

        // execute
        BookstorePublisherController controller = new BookstorePublisherController(stdController);
        controller.getBookstoreBooksCausingError();

        // assert 
        GetBokstoreBooksOnPublsherDeleteServiceMocker.assertMethodExecutionCount('getBookstoreBooks', 1);
        GetBokstoreBooksOnPublsherDeleteServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }

    /**
     * This method doesen't required data and mock as in previous ones because we are testing a static method
     */
    @isTest
    public static void returnBookstoreBooksCausingErrorForLwc_willUseService() {
        // create data
        Id bookstorePublisherId = new TestFactory().getFakeId(Bookstore_Publisher__c.SObjectType, true);
        // create mocks
        Mocker GetBokstoreBooksOnPublsherDeleteServiceMocker = new Mocker(GetBokstoreBooksOnPublsherDeleteService.class);
        GetBokstoreBooksOnPublsherDeleteServiceMocker.setBehavior('getBookstoreBooks', null);
        GetBokstoreBooksOnPublsherDeleteServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            GetBokstoreBooksOnPublsherDeleteService.class.getName(),
            (GetBokstoreBooksOnPublsherDeleteService) GetBokstoreBooksOnPublsherDeleteServiceMocker.getMock()
        );

        // execute
        BookstorePublisherController.returnBookstoreBooksCausingErrorForLwc(bookstorePublisherId, 5);

        // assert 
        GetBokstoreBooksOnPublsherDeleteServiceMocker.assertMethodExecutionCount('getBookstoreBooks', 1);
        GetBokstoreBooksOnPublsherDeleteServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }
}