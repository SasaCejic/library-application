@isTest
public with sharing class TestFactoryTest {
    @isTest
    public static void createPublishers_willCreateFivePublishers() {
        Test.startTest();
        List<Publisher__c> publishersForTest = new TestFactory().createPublishers(5);
        Test.stopTest();
        System.assertEquals(5, publishersForTest.size());
    }
     /*
    * Id used is dummy 18 character Id used for creating the records without inserting
    */
    @isTest
    public static void createBooks_willCreateFiveBooks() {
        Test.startTest();
        List<Book__c> booksForTest = new TestFactory().createBooks(5, 'a043N00000BRi9rQAD');
        Test.stopTest();
        System.assertEquals(5, booksForTest.size());
    }

    @isTest
    public static void createBookstores_willCreateFiveBookstores() {
        Test.startTest();
        List<Bookstore__c> bookstoresForTest = new TestFactory().createBookstores(5);
        Test.stopTest();
        System.assertEquals(5, bookstoresForTest.size());
    }
    /*
    * Id used is dummy 18 character Id used for creating the records without inserting
    */
    @isTest
    public static void createBookstorePublishers_willCreateFiveBookstorePublishers() {
        Test.startTest();
        List<Bookstore_Publisher__c> bkStorePublishers = new TestFactory().createBookstorePublishers(5, 'a043N00000BRi9rQAD', 'a043N00000BRi9rQAD');
        Test.stopTest();
        System.assertEquals(5, bkStorePublishers.size());
    }
    /*
    * Ids used here are dummy 18 character ids just used for creating the objects without insertion
    */
    @isTest
    public static void createBookstoreBooks_willCreatefiveBooks() {
        Test.startTest();
        List<Bookstore_Book__c> bkbooksFortest = new TestFactory().createBookstoreBooks(5,'a043N00000BRi9rQAD','a043N00000BRi9rQAD');
        Test.stopTest();
        System.assertEquals(5,bkbooksFortest.size());
    }
}