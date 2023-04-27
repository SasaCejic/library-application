/*
 * This class is used for selecting Bookstore_Book__c objects from the database
 */
public with sharing class BookstoreBookSelector implements CustomObject {
    /*
     * @param bookstoreId - Id of the bookstore we want to return all the books that are not in there
     */
    public List<Bookstore_Book__c> getListByBookstoreId(Id bookstoreId) {
        return [
            SELECT
                Id,
                Book__c,
                Bookstore__c
            FROM Bookstore_Book__c
            WHERE Bookstore__c = :bookstoreId
        ];
    }
}