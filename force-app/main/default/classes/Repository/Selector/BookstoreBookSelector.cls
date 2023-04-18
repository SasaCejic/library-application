public with sharing class BookstoreBookSelector implements CustomObject{
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