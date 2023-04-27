/*
* This class is used to test logic in the BookTriggerHandler
*/
@isTest
public with sharing class BookTriggerHandlerTest {

    @isTest
    public static void beforeInsert_willUseService() {
        //Mock AuthorPublisher selector so we don't depend on it
        Mocker bookValidationServiceMock = new Mocker(BookValidationService.class)
        .setBehavior('validateAuthorPublisherMatch', null);
        ObjectFactory.mocks.put(
            bookValidationService.class.getName(),
            (BookValidationService)bookValidationServiceMock.getMock()
        );

        BookTriggerHandler bookTriggerHandler = new BookTriggerHandler();
        bookTriggerHandler.beforeInsert(new List<Book__c>{});

        bookValidationServiceMock.assertMethodExecutionCount('validateAuthorPublisherMatch', 1);
    }

    @isTest
    public static void beforeUpdate_willUseService() {
        //Mock AuthorPublisher selector so we don't depend on it
        Mocker bookValidationServiceMock = new Mocker(BookValidationService.class)
        .setBehavior('validateAuthorPublisherMatch', null);
        ObjectFactory.mocks.put(
            bookValidationService.class.getName(),
            (BookValidationService)bookValidationServiceMock.getMock()
        );

        BookTriggerHandler bookTriggerHandler = new BookTriggerHandler();
        bookTriggerHandler.beforeUpdate(new List<Book__c>{},new List<Book__c>{});

        bookValidationServiceMock.assertMethodExecutionCount('validateAuthorPublisherMatch', 1);
    }
}