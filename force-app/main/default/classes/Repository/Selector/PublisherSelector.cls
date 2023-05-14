/*
 * Class used for selectors regarding Publisher__c object
 */
public with sharing class PublisherSelector implements CustomObject{
    /*
     * @param publisherIds - set of publisher Ids which should no tbe retrieved
     */
    public List<Publisher__c> getListNotInIds(Set<Id> publisherIds, Integer recordLimit) {
        return [
            SELECT
                Id,
                Name,
                Phone__c
            FROM Publisher__c
            WHERE Id NOT IN : publisherIds
            LIMIT :recordLimit
        ];
    }

    /*
     * Method returns publishers from the database based on name match
     * @param searchKey - search value 
     */
    public List<Publisher__c> getListByName(String searchKey) {
        return [
            SELECT
                Id,
                Name
            FROM Publisher__c
            WHERE Name like :searchKey
            LIMIT 2000
        ];
    }
}