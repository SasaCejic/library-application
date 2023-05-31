/*
 * Trigger logic is handled by Trigger Dispatcher and Trigger Handler objects
 */
trigger AuthorPublisherTrigger on Author_Publisher__c (before insert, before update, before delete, after insert, after update, after delete) {
    new TriggerDispatcher(Trigger.operationType, new AuthorPublisherTriggerHandler()).dispatch();
}