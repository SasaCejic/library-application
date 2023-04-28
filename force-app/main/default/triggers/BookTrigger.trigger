/*
* Trigger logic is handled by Trigger Dispatcher and Trigger Handler objects
*/
trigger BookTrigger on Book__c (before insert, before update, before delete, after insert, after update, after delete) {
    new TriggerDispatcher(Trigger.operationType, new BookTriggerHandler()).dispatch();
}