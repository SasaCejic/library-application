/**
 * BookstoreBook selector class used to fetch Bookstore_Book__c object data
 * from the database
 * 
 * @see Bookstore_Book__c
 */

public with sharing class BookstoreBookSelector implements CustomObject {
    /**
     * @param bookstoreIds - Ids of the bookstores that Bookstore_Book__c records are assigned to
     * @param recordLimit - Number of records to be retrieved
     */
    public List<Bookstore_Book__c> getListByBookstoreIds(Set<Id> bookstoreIds, Integer recordLimit) {
        return [
            SELECT
                Id,
                Book__c,
                Book__r.Publisher__c,
                Book__r.Name,
                Book__r.Publisher__r.Name,
                Bookstore__r.Name,
                Bookstore__c
            FROM Bookstore_Book__c
            WHERE Bookstore__c IN :bookstoreIds
            LIMIT : recordLimit
        ];
    }

    /**
     * Get all Bookstore__c fields from Bookstore_Book__c junction
     * object records where the book is written by a certain author
     * 
     * @param authorId certain author id
     * 
     * @return Bookstore_Book__c records grouped by Bookstore__c field
     */
    public List<AggregateResult> getListByAuthorId (Id authorId) {
        return [
            SELECT
                Bookstore__c
            FROM
                Bookstore_Book__c
            WHERE
                Book__r.Author__c = :authorId
            GROUP BY
                Bookstore__c
        ];
    }

    /**
     * Get Bookstore_Book__c object records with quantity field
     * for given Bookstore and Book
     * 
     * @param concatanatedIds - concatanated Bookstore and Book ids
     * 
     * @return Bookstore_Book__c records with book quantity, Bookstore and Book values
     */
    public List<Bookstore_Book__c> getListByUniqueConcatanatedIds (Set<String> concatanatedIds) {
        return [
            SELECT
                Id,
                Quantity__c,
                Bookstore__c,
                Book__c,
                Book__r.Name,
                Book__r.Price__c,
                Number_Of_Active_Reservations__c
            FROM 
                Bookstore_Book__c
            WHERE 
                Unique_Concatanated_Ids__c = :concatanatedIds
        ];
    }
}