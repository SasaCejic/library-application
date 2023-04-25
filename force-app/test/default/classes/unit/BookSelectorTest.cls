/*
* This class perfoms tests for Book Selector class
*/
@isTest
public with sharing class BookSelectorTest {
    @istest
    public static void getBooksBySetOfIds_willReturnFiveBook_ifFiveBooksWereInserted() {
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, true, false);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForInsert = testFactory.createBook(publisherForTest.Id, bookDetails, true, false);
        
        Test.startTest();
        Map<Id, Book__c> bookForTest = new BookSelector().getMapByIds(new Set<Id>{bookForInsert.Id});
        Test.stopTest();

        System.assertEquals(bookForTest.values().Id, bookForInsert.Id);
        System.assertEquals(bookForTest.values().Publisher__c, bookForInsert.Publisher__c);
    }
}