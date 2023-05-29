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

    /**
     * @param Id - Id of the Bookstore_Publisher__c record retrieved
     */
    public Author_Publisher__c getRecordById(Id id){
        return [
            SELECT 
                Id,
                Author__c,
                Publisher__c
            FROM Author_Publisher__c
            WHERE Id =: id
        ];
    }

}