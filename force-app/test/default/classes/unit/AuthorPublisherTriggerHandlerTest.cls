/*
 * This class is used to test logic in AuthorPubDeleteValidationService class
 */
@isTest
public with sharing class AuthorPublisherTriggerHandlerTest {
    @isTest
    public static void onDelete_willUseService() {
        // create mock
        Mocker authorPublisherDeleteValidationServiceMocker = new Mocker(AuthorPublisherDeleteValidationService.class)
            .setBehavior('validateAuthorPublisher', null);
        ObjectFactory.mocks.put(
            AuthorPublisherDeleteValidationService.class.getName(),
            (AuthorPublisherDeleteValidationService) authorPublisherDeleteValidationServiceMocker.getMock()
        );

        // execute
        AuthorPublisherTriggerHandler triggerHandler = new AuthorPublisherTriggerHandler();
        triggerHandler.beforeDelete(new List<Author_Publisher__c>());

        // assert
        authorPublisherDeleteValidationServiceMocker.assertMethodExecutionCount('validateAuthorPublisher', 1);
    }
}