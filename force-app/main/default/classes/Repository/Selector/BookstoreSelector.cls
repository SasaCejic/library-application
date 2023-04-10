public with sharing class BookstoreSelector implements CustomObject{
    public List<Bookstore__c> getStoresWithAuthorsBooks(){
        return [
            SELECT
                Id,
                Name
            FROM
                Bookstore__c
        ];
    }
}