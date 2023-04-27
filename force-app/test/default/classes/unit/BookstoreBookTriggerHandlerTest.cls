/*
* This class is used to test logic in BookstoreBookTriggerHandler
*/
@isTest
public with sharing class BookstoreBookTriggerHandlerTest {
    /*
    * No data needed because service will be mocked, just test if it is executed
    */
    @isTest
    public static void beforeInsert_willUseService() {
        Mocker bookstoreBookValidationServiceMock = new Mocker(BookstoreBookValidationService.class)
        .setBehavior('validatePublisher', new List<Bookstore_Book__c>());
        ObjectFactory.mocks.put(
            BookstoreBookValidationService.class.getName(),
            (BookstoreBookValidationService)bookstoreBookValidationServiceMock.getMock()
        );

        BookstoreBookTriggerHandler bookstoreBookTriggerHandler = new BookstoreBookTriggerHandler();
        bookstoreBookTriggerHandler.beforeInsert(new List<Bookstore_Book__c>{});
    
        bookstoreBookValidationServiceMock.assertMethodExecutionCount('validatePublisher', 1);
    }
}