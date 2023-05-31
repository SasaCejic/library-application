/*
 * This class is used to test logic in BookPurchaseTriggerHandler class
 */
@isTest
public with sharing class BookPurchaseTriggerHandlerTest {
    @isTest
    public static void beforeInsert_willUseCorrectService() {
        // create mock
        Mocker BookPurchaseValidationServiceMocker = new Mocker(BookPurchaseValidationService.class)
            .setBehavior('validatePurchase', null);
        ObjectFactory.mocks.put(
            BookPurchaseValidationService.class.getName(),
            (BookPurchaseValidationService) BookPurchaseValidationServiceMocker.getMock()
        );

        // execute
        BookPurchaseTriggerHandler triggerHandler = new BookPurchaseTriggerHandler();
        triggerHandler.beforeInsert(new List<Book_Purchase__c>{});
        
        // assert
        BookPurchaseValidationServiceMocker.assertMethodExecutionCount('validatePurchase', 1);
    }
}