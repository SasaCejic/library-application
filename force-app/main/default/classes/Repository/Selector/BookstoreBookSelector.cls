public with sharing class BookstoreBookSelector {
    public List<Bookstore_Book__c> getBookstoreBooksWithAuthorsBooks(Id authorId){
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
        ];
    }
}