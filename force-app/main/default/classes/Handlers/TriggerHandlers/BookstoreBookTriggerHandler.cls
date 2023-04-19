/*
* This class handles what happens with Bookstore_Book__c object in triggers
* stopTrigger variable serves for disabling trigger during test
*/
public with sharing class BookstoreBookTriggerHandler extends TriggerHandler {
    /*
    * @param - newRecords - records being inserted
    */
    public override void beforeInsert(List<sObject> newRecords) {
        BookstoreBookValidationService bkStoreBookValidation = (BookstoreBookValidationService) new ObjectFactory()
        .createObject(BookstoreBookValidationService.class);
        bkStoreBookValidation.validatePublisher((List<Bookstore_Book__c>) newRecords);
    }
}