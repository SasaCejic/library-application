/*
 * This class automaticaly creates the Anonymous and Unknown out-of-the box Author__c sObjects
 * stopTrigger variable serves for disabling trigger during test
 */
global with sharing class StandardAuthorCreator {
/*
 * Static method that can be executad from the developer console to automatically create the Unknown and Anonymous Author__c records
 */
    public static void create(){
        List<Standard_Authors_Settting__c> stdAuthorSettings = Standard_Authors_Settting__c.getall().values();

        if (stdAuthorSettings.size()>0) {
            return;
        }
        List<Author__c> authorsToCreate = new List<Author__c>();
        Author__c anonymousAuthor = new Author__c(First_Name__c='Anonymous', Last_Name__c='Author');
        authorsToCreate.add(anonymousAuthor);
        Author__c unknownAuthor = new Author__c(First_Name__c='Unknown', Last_Name__c='Author');
        authorsToCreate.add(unknownAuthor);
        insert authorsToCreate;

        //Saves the ids of inserted records as a custom setting as a means of differentiating them from custom Author__c records
        Standard_Authors_Settting__c stdAuthorSettingForInsert = new Standard_Authors_Settting__c();
        stdAuthorSettingForInsert.AnonymousId__c=anonymousAuthor.Id;
        stdAuthorSettingForInsert.UnknownId__c=unknownAuthor.Id;
        insert stdAuthorSettingForInsert;
    }
}