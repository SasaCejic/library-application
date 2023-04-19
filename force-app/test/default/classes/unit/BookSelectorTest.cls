/*
* This class perfoms tests for Book Selector class
*/
@isTest
public with sharing class BookSelectorTest {
    @istest
    public static void getBooksBySetOfIds_willReturnBook() {
        List<Publisher__c> publisherForInsert = new TestFactory().createPublishers(1);
        insert publisherForInsert;
        List<Book__c> booksForInsert = new TestFactory().createBooks(5, publisherForInsert[0].Id);
        insert booksForInsert;
        
        Test.startTest();
        Map<Id, Book__c> bookForTest = new BookSelector().getBooksBySetOfIds(new Set<Id>{booksForInsert[0].Id});
        Test.stopTest();

        System.assertEquals(bookForTest.values()[0].Id, booksForInsert[0].Id);
        System.assertEquals(bookForTest.values()[0].Publisher__c, booksForInsert[0].Publisher__c);
    }
}