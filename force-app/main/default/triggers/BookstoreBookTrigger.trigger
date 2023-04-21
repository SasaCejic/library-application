/*
* Trigger logic is handled by Trigger Dispatcher and Trigger Handler objects
*/
trigger BookstoreBookTrigger on Bookstore_Book__c (before insert, before update, before delete,
after insert, after update, after delete) {
    new TriggerDispatcher(Trigger.operationType, new BookstoreBookTriggerHandler()).dispatch();
}