/**
 * Class used for testing Bookstore_Publisher__c Trigger
 */
@isTest
public with sharing class BookstorePublisherTriggerHandlerTest {
    @isTest
    public static void onDelete_willUseService() {
        // create mock
        Mocker BookstorePublisherDeleteValidationServiceMocker = new Mocker(BookstorePublsherDeleteValidationService.class)
            .setBehavior('validateBookstorePublisher', null);
        ObjectFactory.mocks.put(
            BookstorePublsherDeleteValidationService.class.getName(),
            (BookstorePublsherDeleteValidationService) BookstorePublisherDeleteValidationServiceMocker.getMock()
        );

        // execute
        BookstorePublisherTriggerHandler triggerHandler = new BookstorePublisherTriggerHandler();
        triggerHandler.beforeDelete(new List<Bookstore_Publisher__c>());

        // assert
        BookstorePublisherDeleteValidationServiceMocker.assertMethodExecutionCount('validateBookstorePublisher', 1);
    }
}