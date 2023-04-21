/*
* This class performs tests for Bookstore_Book__c trigger
*/
@isTest
public with sharing class BookstoreBookTriggerTest {
    /*
    * Method performs successfull Publisher validation because it is ran as Book Manager
    */
    @isTest
    public static void onInsert_willAddError_whenBookstorePublisherIsNotAdded() {
        List<Publisher__c> publisherForTest = new TestFactory().createPublishers(1);
        insert publisherForTest;
        List<Bookstore__c> bookstoreForTest = new TestFactory().createBookstores(1);
        insert bookstoreForTest;
        List<Book__c> bookForTest = new TestFactory().createBooks(1, publisherForTest[0].Id);
        insert bookForTest;
        List<Bookstore_Book__c> bkstoreBookForTest = new TestFactory()
        .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);  

        Test.startTest();
        Database.SaveResult[] insertResult = Database.insert(bkstoreBookForTest, false);
        Test.stopTest();

        System.assert(insertResult[0].isSuccess() == false);
    }
}
