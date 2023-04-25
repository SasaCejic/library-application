trigger BookReviewTrigger on Book_Review__c (before insert, before update, before delete, after insert, after update, after delete) {
    new TriggerDispatcher(Trigger.operationType, new BookReviewTriggerHandler()).dispatch();
}