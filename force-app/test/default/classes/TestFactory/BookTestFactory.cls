/*
* Class used for creating Book__c objects only for tests
*/
@isTest
public with sharing class BookTestFactory {
    /*
    * @param numOfBooks - number of books to be created
    * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
    */
    public List<Book__c> createBooks(Integer numOfBooks, Id publisherId) {
        List<Book__c> booksForTest = new List<Book__c>();
        for(Integer i = 0; i<numOfBooks; i++) {
            Book__c currentBook = new Book__c();
            currentBook.Name = 'Book' + i;
            currentBook.Description__c = 'Book Description' + i;
            currentBook.ISBN__c = '555333' + i;
            currentBook.Language__c = 'English';
            currentBook.Categories__c = 'Fantasy';
            currentBook.Publisher__c = publisherId;
            currentBook.Publish_Date__c = Date.newInstance(2022, 1, 1);
            booksForTest.add(currentBook);
        }
        return booksForTest;
    }
}