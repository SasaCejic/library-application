/*
 * This class handles what happens with Author__c object in triggers
 * triggerDisable variable serves for disabling trigger during test
 */
public with sharing class AuthorTriggerHandler extends TriggerHandler{
    @TestVisible
    public static Boolean triggerDisabled = false;

    /*
     * method used to disable trigger 
     */
    public override Boolean isDisabled() {
        return triggerDisabled;
    }
    
    /*
    * @param - oldRecords - records containing old field values
    * @param - newRecords - records containing updated field values
    */ 
    public override void beforeUpdate(List<sObject> oldRecords,List<sObject> newRecords) {
        AuthorValidationService authorValidationServ = (AuthorValidationService) new ObjectFactory()
        .createObject(AuthorValidationService.class);
        authorValidationServ.validateNoStdAuthorChange((List<Author__c>) oldRecords);
    }

    /*
    * @param - oldRecords - records containing old field values 
    */ 
    public override void beforeDelete(List<sObject> oldRecords) {
        AuthorValidationService authorValidationServ = (AuthorValidationService) new ObjectFactory()
        .createObject(AuthorValidationService.class);
        authorValidationServ.validateNoStdAuthorChange((List<Author__c>) oldRecords);
    }
}