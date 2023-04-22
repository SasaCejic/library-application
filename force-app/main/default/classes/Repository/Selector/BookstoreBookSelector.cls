/**
 * BookstoreBook selector class used to fetch Bookstore_Book__c object data
 * from the database
 * 
 * @see Bookstore_Book__c
 */
public with sharing class BookstoreBookSelector implements CustomObject{

    /**
     * Get all Bookstore__c fields from Bookstore_Book__c junction
     * object records where the book is written by a certain author
     * 
     * @param authorId certain author id
     * 
     * @return Bookstore_Book__c records grouped by Bookstore__c field
     */
    public AggregateResult[] getBookstoreBooksWithAuthorsBooks(Id authorId){
        return [
            SELECT
                Bookstore__c
            FROM
                Bookstore_Book__c
            WHERE
                Book__c
            IN (
                SELECT
                    Id
                FROM
                    Book__c
                WHERE
                    Author__c = :authorId
                )
            GROUP BY
                Bookstore__c
        ];
    }
}