/*
 * Class used to validate weather delete of standard Author__c records (Unknown, Anonymous) has been attempted
 * If they are found among the deleted records, the validation will result in an error
 */
public with sharing class AuthorDeleteValidationService implements CustomObject{
    /*
     * @param oldAuthors - Author__c records before delete
     */
    public void validateAuthorDelete(List<Author__c> oldAuthors){
        //get all records of Standard_Authors_Settting__c type 
        CustomSettingSelector customSettingSelector = (CustomSettingSelector) new ObjectFactory()
            .createObject(CustomSettingSelector.class);
        List<Standard_Authors_Settting__c> stdAuthorSettings = customSettingSelector.getStdAuthorsSettingList();

        //if list is empty (no out-of-the box authors have been created), return
        if (stdAuthorSettings.size() == 0) {
            return;
        }

        //search for record ids that match out-of-the box author ids among changed records
        for (Author__c oldAuthor : oldAuthors){
            //if matching records are found, add an error to them
            if (oldAuthor.Id == stdAuthorSettings[0].AnonymousId__c || oldAuthor.Id == stdAuthorSettings[0].UnknownId__c){
                oldAuthor.addError('Out-of-the-box authors (Unknown, Anonymous) cannot be deleted');
            }
        }
    }
}