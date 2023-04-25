/*
* Class used for selecting book reviews from database
*/
public with sharing class BookReviewSelector implements CustomObject {
    /*
    * Method used for retrieving all book reviews from the database
    */
    public List<Book_Review__c> getList() {
        return [
            SELECT
                Id,
                Book__c,
                CreatedById
            FROM Book_Review__c
        ];
    }
}