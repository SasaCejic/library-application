/*
* Class used for testing the class that creates bookstore objects used only in tests written for other classes
*/
@isTest
public with sharing class BookstoreTestFactoryTest {
    @isTest
    public static void createBookstores_willCreateFiveBookstores() {
        Test.startTest();
        List<Bookstore__c> bookstoresForTest = new BookstoreTestFactory().createBookstores(5);
        Test.stopTest();
        System.assertEquals(5, bookstoresForTest.size());
    }
}