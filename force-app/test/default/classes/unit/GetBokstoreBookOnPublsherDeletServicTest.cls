/**
 * Class used for testing GetBookstoreBookOnPublsherDeleteService
 */
@isTest
public with sharing class GetBokstoreBookOnPublsherDeletServicTest {
    @isTest
    public static void getBookstoreBooks_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Id BookstorePublisherId = testFactory.getFakeId(Bookstore_Publisher__c.SObjectType, true);
        // create mocks
        Mocker ReturnBookstorePublisherBasedOnIdServiceMocker = new Mocker(ReturnBookstorePublisherBasedOnIdService.class);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('returnBookstorePublisher', null);
        ReturnBookstorePublisherBasedOnIdServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            ReturnBookstorePublisherBasedOnIdService.class.getName(),
            (ReturnBookstorePublisherBasedOnIdService) ReturnBookstorePublisherBasedOnIdServiceMocker.getMock()
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
        service.getBookstoreBooks(bookstorePublisherId, 5);

        // Assert
        ReturnBookstorePublisherBasedOnIdServiceMocker.assertMethodExecutionCount('returnBookstorePublisher', 1);
        ReturnBookstorePublisherBasedOnIdServiceMocker.assertMethodExecutionCount('getResponse', 1);
        BookstorePublsherDeleteValidationServiceMocker.assertMethodExecutionCount('validateBookstorePublisher', 1);
        BookstorePublsherDeleteValidationServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }
}