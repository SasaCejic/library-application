/*
 * This class handles what happens with Book_Purchase__c object in triggers
 * triggerDisable variable serves for disabling trigger during test
 */
public with sharing class BookPurchaseTriggerHandler extends TriggerHandler{
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
        BookPurchaseValidationService service = (BookPurchaseValidationService) new ObjectFactory()
            .createObject(BookPurchaseValidationService.class);
        service.validatePurchase(newRecords);
    }
}