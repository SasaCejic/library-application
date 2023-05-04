/**
 * This class performs tests for Bookstore__c object trigger
 * 
 * @see BookstoreTrigger.trigger
 */
@isTest
public with sharing class BookstoreTriggerTest {
    @isTest
    public static void onInsert_WillAddError_IfUserIsManagerOfSomeBookstore() {
        // create data
        TestFactory testFactory = new TestFactory();
        User userForTest = testFactory.createUser(true, false);
        Bookstore__c bookstore1 = testFactory.createBookstore(true, false);
        //make user manager of the bookstore
        bookstore1.Manager__c = userForTest.Id;
        update bookstore1;
        Bookstore__c bookstore2 = testFactory.createBookstore(false, true);
        //make user manager of the bookstore
        bookstore2.Manager__c = userForTest.Id;

        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookstore2, false);
        Test.stopTest();

        Assert.isTrue(insertResult.getErrors().size() == 1);
    }

    @isTest
    public static void onUpdate_WillAddError_IfUserIsManagerOfSomeBookstore() {
        // create data
        TestFactory testFactory = new TestFactory();
        User userForTest = testFactory.createUser(true, false);
        Bookstore__c bookstore1 = testFactory.createBookstore(true, false);
        //make user manager of the bookstore
        bookstore1.Manager__c = userForTest.Id;
        update bookstore1;
        Bookstore__c bookstore2 = testFactory.createBookstore(true, false);
        //make user manager of the bookstore
        bookstore2.Manager__c = userForTest.Id;

        Test.startTest();
        Database.SaveResult updateResult = Database.update(bookstore2, false);
        Test.stopTest();

        Assert.isTrue(updateResult.getErrors().size() == 1);
    }
}