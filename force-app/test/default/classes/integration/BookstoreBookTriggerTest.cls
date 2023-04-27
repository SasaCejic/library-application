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
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true, false);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, true, false);
        Bookstore_Book__c bookstoreBookForTest = testFactory
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false, false);  

        // execute
        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookstoreBookForTest, false);
        Test.stopTest();

        // assert
        Assert.isTrue(insertResult.isSuccess() == false);
    }
}
