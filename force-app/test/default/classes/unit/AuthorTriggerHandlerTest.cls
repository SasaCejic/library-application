/*
 * This class is used to test logic in AuthorTriggerHandler
 */
@isTest
public with sharing class AuthorTriggerHandlerTest {
     @isTest
    public static void beforeUpdate_willUseCorrectService() {
        // create mock
        Mocker AuthorValidationServiceMocker = new Mocker(AuthorValidationService.class)
        .setBehavior('validateAuthorUpdate', new List<Author__c>{});
        ObjectFactory.mocks.put(
            AuthorValidationService.class.getName(),
            (AuthorValidationService)AuthorValidationServiceMocker.getMock()
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
        Mocker AuthorValidationServiceMocker = new Mocker(AuthorValidationService.class)
        .setBehavior('validateAuthorDelete', new List<Author__c>{});
        ObjectFactory.mocks.put(
            AuthorValidationService.class.getName(),
            (AuthorValidationService)AuthorValidationServiceMocker.getMock()
        );

        // execute
        AuthorTriggerHandler triggerHandler = new AuthorTriggerHandler();
        triggerHandler.beforeDelete(new List<Author__c>{});
        
        // assert
        AuthorValidationServiceMocker.assertMethodExecutionCount('validateAuthorDelete', 1);
    }
}