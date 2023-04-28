/*
 * This class is used to test logic in BookstoreBookTriggerHandler
 */
@isTest
public with sharing class BookstoreBookTriggerHandlerTest {
    @isTest
    public static void beforeInsert_willUseService() {
        //disable triger unrelated to test
        BookTriggerHandler.triggerDisabled=true;
        // create mock
        Mocker bookstoreBookValidationServiceMock = new Mocker(BookstoreBookValidationService.class)
        .setBehavior('validatePublisher', new List<Bookstore_Book__c>());
        ObjectFactory.mocks.put(
            BookstoreBookValidationService.class.getName(),
            (BookstoreBookValidationService)bookstoreBookValidationServiceMock.getMock()
        );

        // execute
        BookstoreBookTriggerHandler bookstoreBookTriggerHandler = new BookstoreBookTriggerHandler();
        bookstoreBookTriggerHandler.beforeInsert(new List<Bookstore_Book__c>{});
        
        //assert
        bookstoreBookValidationServiceMock.assertMethodExecutionCount('validatePublisher', 1);
    }
}