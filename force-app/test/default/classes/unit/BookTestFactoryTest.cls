/*
* Class used for testing the class that creates book objects used only in tests written for other classes
*/
@isTest
public with sharing class BookTestFactoryTest {
    /*
    * Id used is dummy 18 character Id used for creating the records without inserting
    */
    @isTest
    public static void createBooks_willCreateFiveBooks() {
        Test.startTest();
        List<Book__c> booksForTest = new BookTestFactory().createBooks(5, 'a043N00000BRi9rQAD');
        Test.stopTest();
        System.assertEquals(5, booksForTest.size());
    }
}