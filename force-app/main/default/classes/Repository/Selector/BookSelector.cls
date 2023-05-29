/*
 * Class performs database selectors for Book__c objects
 */
public with sharing class BookSelector implements CustomObject {
    /*
     * Method returns a map of added bookstoreBooks and their publishers
     * @param BookId - Id of the book being retrieve
     */
    public Map<Id, Book__c> getMapByIds(Set<Id> bookIds) {
        return new Map<Id, Book__c>([
            SELECT
                Id,
                Publisher__c
            FROM Book__c
            WHERE Id In :bookIds
        ]);
    }
    
    /*
     * @param bookIds - set of book Ids which should not be retrieved
     */
    public List<Book__c> getListNotInIds(Set<Id> bookIds, Integer recordLimit) {
        return [
            SELECT
                Id,
                Name,
                ISBN__c
            FROM Book__c
            WHERE Id NOT IN :bookIds
            LIMIT :recordLimit
        ];
    }

    /*
     * @param bookIds - set of author Ids to retieve by
     */
    public List<Book__c> getListByAuthorIds(Set<Id> authorIds, Integer recordLimit) {
        return [
            SELECT
                Id,
                Name,
                Author__r.Name,
                Publisher__r.Name
            FROM Book__c
            WHERE Author__c IN :authorIds
            LIMIT :recordLimit
        ];
    }

    /**
     * Get Book__c record by it's ID value
     * 
     * @param bookId id of the book we are looking for
     */
    public Book__c getBookById (Id bookId) {
        return [
            SELECT
                Name,
                Price__c
            FROM
                Book__c
            WHERE Id = :bookId
            LIMIT 1
        ];
    }

    /**
     * @param bookISBNs - set of book ISBNs to retrieve books
     */
    public list<Book__c> getListByISBNs(Set<String> setOfISBNs) {
        return [
            SELECT
                Id,
                Name,
                ISBN__c
            FROM Book__c
            WHERE ISBN__c IN :setOfISBNs
        ];
    }
}