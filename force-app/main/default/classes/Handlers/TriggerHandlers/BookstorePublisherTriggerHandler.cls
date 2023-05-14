/*
 * This class handles what happens with Bookstore_Publisher__c object in triggers
 * triggerDisable variable serves for disabling trigger during test
 */
public with sharing class BookstorePublisherTriggerHandler extends TriggerHandler {
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
    public override void beforeDelete(List<sObject> oldRecords) {
        BookstorePublsherDeleteValidationService service = (BookstorePublsherDeleteValidationService) new ObjectFactory()
            .createObject(BookstorePublsherDeleteValidationService.class);
        service.validateBookstorePublisher((List<Bookstore_Publisher__c>) oldRecords);
    }
}