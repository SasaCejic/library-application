/**
 * This class is used to test the logic in BookstoreTriggerHandler
 * 
 * @see BookstoreTriggerHandler.cls
 */
@isTest
public with sharing class BookstoreTriggerHandlerTest {
    @isTest
    public static void beforeInsert_WillUseService() {
        //disable triger unrelated to test
        BookstoreTriggerHandler.triggerDisabled=true;

        // create mock
        Mocker bookstoreValidationServiceMock = new Mocker(BookstoreValidationService.class)
        .setBehavior('validateBookstoreManagerMatch', new List<Bookstore__c>());
        ObjectFactory.mocks.put(
            BookstoreValidationService.class.getName(),
            (BookstoreValidationService)bookstoreValidationServiceMock.getMock()
        );

        // execute
        BookstoreTriggerHandler bookstoreTriggerHandler = new BookstoreTriggerHandler();
        bookstoreTriggerHandler.beforeInsert(new List<Bookstore__c>{});
        
        //assert
        bookstoreValidationServiceMock.assertMethodExecutionCount('validateBookstoreManagerMatch', 1);
    }

    @isTest
    public static void beforeUpdate_WillUseService() {
         //disable triger unrelated to test
         BookstoreTriggerHandler.triggerDisabled=true;
         
         // create mock
         Mocker bookstoreValidationServiceMock = new Mocker(BookstoreValidationService.class)
         .setBehavior('validateBookstoreManagerMatch', new List<Bookstore__c>());
         ObjectFactory.mocks.put(
             BookstoreValidationService.class.getName(),
             (BookstoreValidationService)bookstoreValidationServiceMock.getMock()
         );
 
         // execute
         BookstoreTriggerHandler bookstoreTriggerHandler = new BookstoreTriggerHandler();
         bookstoreTriggerHandler.beforeUpdate(new List<Bookstore__c>{}, new List<Bookstore__c>{});
         
         //assert
         bookstoreValidationServiceMock.assertMethodExecutionCount('validateBookstoreManagerMatch', 1);
 
    }
}