/**
 * Trigger logic is handled by Trigger Dispatcher and Trigger Handler objects
 */
trigger BookReservationTrigger on Book_Reservation__c (before insert, before update, before delete, after insert, after update, after delete) {
    new TriggerDispatcher(Trigger.operationType, new BookReservationTriggerHandler()).dispatch();
}