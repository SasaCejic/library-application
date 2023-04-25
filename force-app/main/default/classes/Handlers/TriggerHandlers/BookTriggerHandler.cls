/*
* This class handles what happens with Book__c sObjects in triggers
* disabled variable serves for disabling trigger during test
*/
public with sharing class BookTriggerHandler extends TriggerHandler {
@TestVisible
    private static Boolean triggerDisabled = false;
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
        BookValidationService bookValidationServ = (BookValidationService) new ObjectFactory()
        .createObject(BookValidationService.class);
        bookValidationServ.validateAuthorPublisherMatch((List<Book__c>) newRecords);
    }

    /*
    * @param - oldRecords - records containing old field values
    * @param - newRecords - records containing updated field values
    */ 
    public override void beforeUpdate(List<sObject> oldRecords,List<sObject> newRecords) {
        BookValidationService bookValidationServ = (BookValidationService) new ObjectFactory()
        .createObject(BookValidationService.class);
        bookValidationServ.validateAuthorPublisherMatch((List<Book__c>) newRecords);
    }
}