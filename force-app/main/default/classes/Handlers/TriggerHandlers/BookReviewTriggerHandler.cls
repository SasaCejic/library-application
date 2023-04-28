/*
 * This class handles what happens with Bookstore_Book__c object in triggers
 * triggerDisable variable serves for disabling trigger during test
 */
public with sharing class BookReviewTriggerHandler extends TriggerHandler{
    @TestVisible
    public static Boolean triggerDisabled = false;

    /*
     * method used to disable trigger 
     */
    public override Boolean isDisabled() {
        return triggerDisabled;
    }
    
    /*
     * @param - newRecords - records being inserted
     */
    public override void beforeInsert(List<sObject> newRecords) {
        BookReviewValidationService bookReviewValidation = (BookReviewValidationService) new ObjectFactory()
            .createObject(BookReviewValidationService.class);
        bookReviewValidation.validateReview((List<Book_Review__c>) newRecords);
    }
}