/*
 * Class used to validate weather edit or delete of standard Author__c records (Unknown, Anonymous) has been attempted
 * If any change has been made to them, the validation will result in an error
 */
public with sharing class AuthorValidationService implements CustomObject {
    /*
     * @param changedAuthors - Author__c records being updated or deleted
     */
    public void validateNoStdAuthorChange(List<Author__c> changedAuthors){
        //get all records of Standard_Authors_Settting__c type 
        CustomSettingSelector customSettingSelector = (CustomSettingSelector) new ObjectFactory()
            .createObject(CustomSettingSelector.class);
        List<Standard_Authors_Settting__c> stdAuthorSettings = customSettingSelector.getStdAuthorsSettingList();

        //if list is empty (no out-of-the box authors have been created), return
        if (stdAuthorSettings.size() == 0) {
            return;
        }

        //search for record ids that match out-of-the box author ids among changed records
        for (Author__c changedAuthor : changedAuthors){
            //if matching records are found, add an error to them
            if (changedAuthor.Id == stdAuthorSettings[0].AnonymousId__c || changedAuthor.Id == stdAuthorSettings[0].UnknownId__c){
                changedAuthor.addError('Out-of-the-box authors (Unknown, Anonymous) cannot be edited or deleted');
            }
        }
    }
}