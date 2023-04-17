/*
* Trigger logic is handled by Trigger Dispatcher and Trigger Handler objects
*/
trigger BookstoreBookTrigger on Bookstore_Book__c (before insert, before update, before delete,
after insert, after update, after delete) {
    TriggerDispatcher Dispatcher = new TriggerDispatcher();
    TriggerHandler bookstoreBookTriggerHandler = new BookstoreBookTriggerHandler();
    Dispatcher.dispatch(Trigger.operationType, bookstoreBookTriggerHandler);
}