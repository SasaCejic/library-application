/*
 * This class handles what happens with Author_Publisher__c object in triggers
 * triggerDisable variable serves for disabling trigger during test
 */
public with sharing class AuthorPublisherTriggerHandler extends TriggerHandler{
    @TestVisible
    public static Boolean triggerDisabled = false;
    
    /*
     * method used to disable trigger 
     */
    public override Boolean isDisabled() {
        return triggerDisabled;
    }

    /**
     * @param oldRecords - records being deleted
     */
    public override void beforeDelete(List<sObject> oldRecords) {
        AuthorPublisherDeleteValidationService service = (AuthorPublisherDeleteValidationService) new ObjectFactory()
            .createObject(AuthorPublisherDeleteValidationService.class);
        service.validateAuthorPublisher((List<Author_Publisher__c>) oldRecords, 2000);
    }
}