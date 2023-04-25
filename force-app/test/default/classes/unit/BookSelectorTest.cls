/*
* This class perfoms tests for Book Selector class 
*/
@isTest
public with sharing class BookSelectorTest {
    @istest
    public static void getBooksBySetOfIds_willReturnFiveBook_ifFiveBooksWereInserted() {
        BookTriggerHandler.triggerDisabled=true;
        //create Data for tests
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, true, false);

        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('firstName', 'Author');
        authorDetails.put('lastName', 'Author');
        Author__c authorForTest = testFactory.createAuthor(authorDetails, true, false);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForInsert = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, true, false);
        
        Test.startTest();
        Map<Id, Book__c> bookForTest = new BookSelector().getMapByIds(new Set<Id>{bookForInsert.Id});
        Test.stopTest(); 

        System.assertEquals((bookForTest.values()[0]).Id, bookForInsert.Id);
        System.assertEquals((bookForTest.values()[0]).Publisher__c, bookForInsert.Publisher__c);
    }
}