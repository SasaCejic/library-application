/**
 * Class used for testing GetBookstoreBookOnPublsherDeleteService
 */
@isTest
public with sharing class GetBokstoreBookOnPublsherDeletServicTest {
    @isTest
    public static void getBookstoreBooks_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false, true);
        // create mocks
        Mocker BookstorePublisherSelectorMocker = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getRecordById', bookstorePublisherForTest);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMocker.getMock()
        );

        Mocker BookstorePublsherDeleteValidationServiceMocker = new Mocker(BookstorePublsherDeleteValidationService.class);
        BookstorePublsherDeleteValidationServiceMocker.setBehavior('validateBookstorePublisher', null);
        BookstorePublsherDeleteValidationServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            BookstorePublsherDeleteValidationService.class.getName(),
            (BookstorePublsherDeleteValidationService) BookstorePublsherDeleteValidationServiceMocker.getMock()
        );

        // execute
        GetBookstoreBookOnPublsherDeleteService service = new GetBookstoreBookOnPublsherDeleteService();
        service.getBookstoreBooks(bookstorePublisherForTest.Id, 5);

        // Assert
        BookstorePublisherSelectorMocker.assertMethodExecutionCount('getRecordById', 1);
        BookstorePublsherDeleteValidationServiceMocker.assertMethodExecutionCount('validateBookstorePublisher', 1);
        BookstorePublsherDeleteValidationServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }
}