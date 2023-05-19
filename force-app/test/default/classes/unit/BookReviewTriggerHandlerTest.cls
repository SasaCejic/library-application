/*
 * This class is used to test logic in BookReviewTriggerHandler
 */
@isTest
public with sharing class BookReviewTriggerHandlerTest {
    @isTest
    public static void beforeInsert_willUseCorrectService() {
        // create mock
        Mocker BookReviewValidationServiceMocker = new Mocker(BookReviewValidationService.class)
            .setBehavior('validateReview', new Book_Review__c());
        ObjectFactory.mocks.put(
            BookReviewValidationService.class.getName(),
            (BookReviewValidationService)BookReviewValidationServiceMocker.getMock()
        );

        // execute
        BookReviewTriggerHandler triggerHandler = new BookReviewTriggerHandler();
        triggerHandler.beforeInsert(new List<Book_Review__c>{});
        
        // assert
        BookReviewValidationServiceMocker.assertMethodExecutionCount('validateReview', 1);
    }
}