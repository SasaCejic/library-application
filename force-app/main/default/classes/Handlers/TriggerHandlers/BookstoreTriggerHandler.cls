/**
 * This class handles what happens with Bookstore__c object in triggers
 * 
 * @see Bookstore__c
 * @see BookstoreTrigger.trigger
 */
public with sharing class BookstoreTriggerHandler extends TriggerHandler {
    
    /**
     * Variable to disable the trigger during tests
     */
    @TestVisible
    private static Boolean triggerDisabled = false;

    /**
     * Method used to check if trigger is disabled during tests
     * 
     * @return triggerDisabled field
     */
    public override Boolean isDisabled () {
        return triggerDisabled;
    }

    /**
     * Method called before insertion of new records
     * 
     * @param newRecords records being inserted
     */
    public override void beforeInsert (List<sObject> newRecords) {
        BookstoreValidationService bookstoreValidationService = (BookstoreValidationService) new ObjectFactory()
        .createObject(BookstoreValidationService.class);
        bookstoreValidationService.validateBookstoreManagerMatch((List<Bookstore__c>) newRecords);
    }

    /**
     * Method called before record update
     * 
     * @param oldRecords records containing old values
     * @param newRecords records containing new values
     */
    public override void beforeUpdate (List<sObject> oldRecords,List<sObject> newRecords) {
        BookstoreValidationService bookstoreValidationService = (BookstoreValidationService) new ObjectFactory()
        .createObject(BookstoreValidationService.class);
        bookstoreValidationService.validateBookstoreManagerMatch((List<Bookstore__c>) oldRecords, (List<Bookstore__c>) newRecords);
    }
}