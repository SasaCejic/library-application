/*
* Class used to test the test factory class that creates bookstore_Book__c object only used when testing other classes
*/
@isTest
public with sharing class BookstoreBookTestFactoryTest {
    /*
    * Ids used here are dummy 18 character ids just used for creating the objects without insertion
    */
    @isTest
    public static void createBookstoreBooks_willCreatefiveBooks() {
        Test.startTest();
        List<Bookstore_Book__c> bkbooksFortest = new BookstoreBookTestFactory().createBookstoreBooks(5,'a043N00000BRi9rQAD','a043N00000BRi9rQAD');
        Test.stopTest();
        System.assertEquals(5,bkbooksFortest.size());
    }
}