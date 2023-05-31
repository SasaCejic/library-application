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
        //disable triger unrelated to test
        BookTriggerHandler.triggerDisabled=true;
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false);
        insert bookstoreForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;
        Bookstore_Book__c bookstoreBookForTest = testFactory
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false);  

        // execute
        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookstoreBookForTest, false);
        Test.stopTest();

        // assert
        Assert.isTrue(insertResult.isSuccess() == false);
    }
}
