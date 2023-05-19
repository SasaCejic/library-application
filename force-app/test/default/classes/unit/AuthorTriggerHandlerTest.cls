/*
 * This class is used to test logic in AuthorTriggerHandler
 */
@isTest
public with sharing class AuthorTriggerHandlerTest {
     @isTest
    public static void beforeUpdate_willUseCorrectService() {
        // create mock
        Mocker AuthorValidationServiceMocker = new Mocker(AuthorUpdateValidationService.class)
        .setBehavior('validateAuthorUpdate', new List<Author__c>{});
        ObjectFactory.mocks.put(
            AuthorUpdateValidationService.class.getName(),
            (AuthorUpdateValidationService)AuthorValidationServiceMocker.getMock()
        );

        // execute
        AuthorTriggerHandler triggerHandler = new AuthorTriggerHandler();
        triggerHandler.beforeUpdate(new List<Author__c>{}, new List<Author__c>{});
        
        // assert
        AuthorValidationServiceMocker.assertMethodExecutionCount('validateAuthorUpdate', 1);
    }

    @isTest
    public static void beforeDelete_willUseCorrectService() {
        // create mock
        Mocker AuthorValidationServiceMocker = new Mocker(AuthorDeleteValidationService.class)
        .setBehavior('validateAuthorDelete', new List<Author__c>{});
        ObjectFactory.mocks.put(
            AuthorDeleteValidationService.class.getName(),
            (AuthorDeleteValidationService)AuthorValidationServiceMocker.getMock()
        );

        // execute
        AuthorTriggerHandler triggerHandler = new AuthorTriggerHandler();
        triggerHandler.beforeDelete(new List<Author__c>{});
        
        // assert
        AuthorValidationServiceMocker.assertMethodExecutionCount('validateAuthorDelete', 1);
    }
}