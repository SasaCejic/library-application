public with sharing class BookstoreSelector implements CustomObject{
    public List<Bookstore__c> getBookstoresWithAuthorsBooks(List<Id> bookstoreIds){
        return [
            SELECT
                Id,
                Name
            FROM
                Bookstore__c
            WHERE
                Id IN :bookstoreIds
        ];
    }
}