/*
* Class performs database selectors for Book__c objects
*/
public with sharing class BookSelector implements CustomObject {
    /*
    * Method returns Book object that corresponds to bookId
    * @param BookId - Id of the book being retrieved
    */
    public List<Book__c> getBookById(Id bookId) {
        return [
            SELECT
                Id,
                Publisher__c
            FROM Book__c
            WHERE Id =: bookId
        ];
    }
}