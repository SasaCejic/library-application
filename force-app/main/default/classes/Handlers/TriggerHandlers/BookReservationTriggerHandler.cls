/**
 * This class handles what happens with Book_Reservation__c object in triggers
 * 
 * @see Book_Reservation__c
 * @see BookReservationTrigger.trigger
 */
public with sharing class BookReservationTriggerHandler extends TriggerHandler {
      
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
        BookReservationValidationService bookReservationValidationService = (BookReservationValidationService) new ObjectFactory()
        .createObject(BookReservationValidationService.class);
        bookReservationValidationService.validateSelectedBook((List<Book_Reservation__c>) newRecords);
    }

    /**
     * Method called before record update
     * 
     * @param oldRecords records containing old values
     * @param newRecords records containing new values
     */
    public override void beforeUpdate (List<sObject> oldRecords,List<sObject> newRecords) {
        BookReservationValidationService bookReservationValidationService = (BookReservationValidationService) new ObjectFactory()
        .createObject(BookReservationValidationService.class);
        bookReservationValidationService.validateSelectedBook((List<Book_Reservation__c>) oldRecords, (List<Book_Reservation__c>) newRecords);
    }
}