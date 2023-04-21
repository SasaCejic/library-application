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
        List<Publisher__c> publishersForTest = new TestFactory().createPublishers(1);
        insert publishersForTest;
        Test.startTest();
        List<Book__c> booksForTest = new TestFactory().createBooks(5, publishersForTest[0].Id);
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
        List<Publisher__c> publishersForTest = new TestFactory().createPublishers(1);
        insert publishersForTest;
        List<Bookstore__c> bookstoresForTest = new TestFactory().createBookstores(1);
        insert bookstoresForTest;
        Test.startTest();
        List<Bookstore_Publisher__c> bookStorePublishers = new TestFactory().createBookstorePublishers(5, publishersForTest[0].Id, bookstoresForTest[0].Id);
        Test.stopTest();
        System.assertEquals(5, bookStorePublishers.size());
    }
    /*
    * Ids used here are dummy 18 character ids just used for creating the objects without insertion
    */
    @isTest
    public static void createBookstoreBooks_willCreatefiveBooks() {
        List<Publisher__c> publishersForTest = new TestFactory().createPublishers(1);
        insert publishersForTest;
        List<Book__c> booksForTest = new TestFactory().createBooks(1, publishersForTest[0].Id);
        insert booksForTest;
        List<Bookstore__c> bookstoresForTest = new TestFactory().createBookstores(1);
        Test.startTest();
        List<Bookstore_Book__c> bookbooksFortest = new TestFactory().createBookstoreBooks(5, booksForTest[0].Id, bookstoresForTest[0].Id);
        Test.stopTest();
        System.assertEquals(5,bookbooksFortest.size());
    }
}