/*
* Class used for creating Bookstore_Book__c objects only for tests
*/
@isTest
public with sharing class BookstoreBookTestFactory {
    /*
    * @param numOfBookstoreBooks - Number of objects we want to create
    * @param bookId - Id of a book which is a parent in master-detail relationship with Bookstore_Book__c
    * @param bookstoreId - Id of a bookstore which isa a parent in master-detail relationship with Bookstore_Book__c
    */
    public List<Bookstore_Book__c> createBookstoreBooks(Integer numOfBookstoreBooks, Id bookId, Id bookstoreId) {
        List<Bookstore_Book__c> bookStoreBooksForTest = new List<Bookstore_Book__c>();
        for(Integer i = 0; i<numOfBookstoreBooks; i++) {
            Bookstore_Book__c newBookstoreBook = new Bookstore_Book__c();
            newBookstoreBook.Book__c = bookId;
            newBookstoreBook.Bookstore__c = bookstoreId;
            bookStoreBooksForTest.add(newBookstoreBook);
        }
        return bookStoreBooksForTest;
    }
}