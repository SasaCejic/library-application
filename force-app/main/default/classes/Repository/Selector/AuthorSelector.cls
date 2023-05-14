/*
 * Class used for selecting authors from database
 */
public with sharing class AuthorSelector implements CustomObject{
    /*
     * Method returns authors from the database based on name match
     * @param searchKey - search value 
     */
    public List<Author__c> getListByName(String searchKey) {
        return [
            SELECT
                Id,
                Name
            FROM Author__c
            WHERE Name like :searchKey
            LIMIT 2000
        ];
    }
}