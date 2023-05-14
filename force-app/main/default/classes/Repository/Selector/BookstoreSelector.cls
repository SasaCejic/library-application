/**
 * Bookstore selector class used to fetch Bookstore__c object data
 * from the database
 * 
 * @see Bookstore__c
 */
public with sharing class BookstoreSelector implements CustomObject {

    /**
     * Get all Bookstore__c object records with Id, Name and Email__c
     * fields where record id is in the passed parameter list
     * 
     * @param bookstoreIds list of Bookstore__c object ids
     * 
     * @return list of Bookstore__c object records
     */
    public List<Bookstore__c> getListByIds(Set<Id> bookstoreIds) {
        return [
            SELECT
                Id,
                Name,
                Email__c
            FROM
                Bookstore__c
            WHERE
                Id IN :bookstoreIds
        ];
    }

    /*
     * Method returns bookstores from the database based on name match
     * @param searchKey - search value 
     */
    public List<Bookstore__c> getListByName(String searchKey) {
        return [
            SELECT
                Id,
                Name
            FROM Bookstore__c
            WHERE Name like :searchKey
            LIMIT 2000
        ];
    }
}