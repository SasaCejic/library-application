/*
* This class is used to test logic in BookReviewTriggerHandler
*/
@isTest
public with sharing class BookReviewTriggerHandlerTest {
    @isTest
    public static void beforeInsert_willUseCorrectService() {
        Mocker BookReviewValidationServiceMocker = new Mocker(BookReviewValidationService.class)
        .setBehavior('validateReview', new Book_Review__c());
        ObjectFactory.mocks.put(
            BookReviewValidationService.class.getName(),
            (BookReviewValidationService)BookReviewValidationServiceMocker.getMock()
        );

        Test.startTest();
        BookReviewTriggerHandler triggerHandler = new BookReviewTriggerHandler();
        triggerHandler.beforeInsert(new List<Book_Review__c>{});
        Test.stopTest();
        
        BookReviewValidationServiceMocker.assertMethodExecutionCount('validateReview', 1);
    }
}