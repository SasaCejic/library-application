/*
* This class handles what happens with Bookstore_Book__c object in triggers
* triggerDisable variable serves for disabling trigger during test
*/
public with sharing class BookstoreBookTriggerHandler extends TriggerHandler {
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
        BookstoreBookValidationService bkStoreBookValidation = (BookstoreBookValidationService) new ObjectFactory()
            .createObject(BookstoreBookValidationService.class);
        bkStoreBookValidation.validatePublisher((List<Bookstore_Book__c>) newRecords);
    }
}