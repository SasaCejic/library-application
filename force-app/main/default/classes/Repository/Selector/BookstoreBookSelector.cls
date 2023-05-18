/**
 * BookstoreBook selector class used to fetch Bookstore_Book__c object data
 * from the database
 * 
 * @see Bookstore_Book__c
 */

public with sharing class BookstoreBookSelector implements CustomObject {
    /**
     * @param bookstoreId - Id of the bookstore we want to return all the books that are not in there
     * @param recordLimit - Number of records to be retrieved from database
     */
    public List<Bookstore_Book__c> getListByBookstoreId(Id bookstoreId, Integer recordLimit) {
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
            WHERE Bookstore__c = :bookstoreId
            LIMIT : recordLimit
        ];
    }

    /**
     * @param bookstoreIds - Ids of the bookstores that Bookstore_Book__c records are assigned to
     */
    public List<Bookstore_Book__c> getListByBookstoreIds(Set<Id> bookstoreIds) {
        return [
            SELECT
                Id,
                Book__c,
                Book__r.Publisher__c,
                Book__r.Name,
                Book__r.Publisher__r.Name,
                Bookstore__c
            FROM Bookstore_Book__c
            WHERE Bookstore__c IN :bookstoreIds
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
    public List<AggregateResult> getListByAuthorId(Id authorId) {
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
}