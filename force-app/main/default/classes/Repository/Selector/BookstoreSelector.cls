/**
 * Bookstore selector class used to fetch Bookstore__c object data
 * from the database
 * 
 * @see Bookstore__c
 */
public with sharing class BookstoreSelector implements CustomObject {

    /**
     * Get all Bookstore__c object records with Id, Name, Email__c
     * and Manager__c fields where Manager Id equal to parameter
     * 
     * @return list of Bookstore__c object records
     */
    public List<Bookstore__c> getListByManagers(Set<Id> managerIds) {
        return [
            SELECT
                Id,
                Name,
                Email__c,
                Manager__c
            FROM
                Bookstore__c
            WHERE
                Manager__c IN :managerIds
        ];
    }

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
}