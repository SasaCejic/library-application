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
}