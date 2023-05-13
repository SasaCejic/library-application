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
     * Method returns searched digital books
     * @param digitalBookRecordTypeId - id of digital book record type
     * @param searchTerm - search value 
     */
    public List<Book__c> getDigitalBooksList(Id digitalBookRecordTypeId, String searchTerm) {
        return [
            SELECT
                Id,
                Name,
                ISBN__c,
                Price__c
            FROM Book__c
            WHERE RecordTypeId =: digitalBookRecordTypeId
            AND 
            NAME LIKE :searchTerm
            LIMIT 2000
        ];
    }
}