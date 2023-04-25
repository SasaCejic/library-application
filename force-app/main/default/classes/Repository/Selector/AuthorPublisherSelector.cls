/*
* Class performs database selectors for Author_Publisher__c junction object
*/
public with sharing class AuthorPublisherSelector implements CustomObject{
    /*
    * Method fetches all Author_Publisher__c objects
    */
    public List<Author_Publisher__c> getList() {
        return [
            SELECT
                Id,
                Author__c,
                Publisher__c
            FROM
                Author_Publisher__c
        ];
    }

}