/*
 * Class used to validate weather update standard Author__c records (Unknown, Anonymous) has been attempted
 * If any change has been made to them, the validation will result in an error
 */
public with sharing class AuthorUpdateValidationService implements CustomObject {
    /*
     * @param oldAuthors - Author__c records before update
     * @param newAuthors - Author__c records after update
     */
    public void validateAuthorUpdate(List<Author__c> oldAuthors, List<Author__c> newAuthors){
        //a set of fields for which validation is skipped and edit is enabled on standard author records
        Set<String> editableStandardAuthorFields= new Set<String>{'number_of_published_books__c', 'lastmodifiedbyid', 'lastmodifiedate'};

        //get all records of Standard_Authors_Settting__c type 
        CustomSettingSelector customSettingSelector = (CustomSettingSelector) new ObjectFactory()
            .createObject(CustomSettingSelector.class);
        List<Standard_Authors_Settting__c> stdAuthorSettings = customSettingSelector.getStdAuthorsSettingList();

        //if list is empty (no out-of-the box authors have been created), return
        if (stdAuthorSettings.size() == 0) {
            return;
        }

        //create map of oldAuthorRecords and map of Author__c fields
        Map<Id,Author__c> oldAuthorMap = new Map<Id,Author__c>(oldAuthors);
        Schema.DescribeSObjectResult authorDescribeRes = Schema.getGlobalDescribe().get('Author__c').getDescribe();
        Map<String, Schema.SObjectField> mapOfAuthorFields = authorDescribeRes.fields.getMap();

        //search for record ids that match out-of-the box author ids among changed records
        for (Author__c newAuthor : newAuthors){
            //if matching records are found, iterate through all of their fields and validate changes
            if (newAuthor.Id == stdAuthorSettings[0].AnonymousId__c || newAuthor.Id == stdAuthorSettings[0].UnknownId__c){                
                for(String fieldName : mapOfAuthorFields.keySet()){
                    //allow field changes for Number_Of_Published_Books__c, otherwise add error to edited Author__c record
                    if (!editableStandardAuthorFields.contains(fieldName) && newAuthor.get(fieldName)!=oldAuthorMap.get(newAuthor.Id).get(fieldName)) {
                        newAuthor.addError('Out-of-the-box authors (Unknown, Anonymous) cannot be edited save for assigning them to books');
                        break;      
                    }
                }
                
            }
        }
    }
}