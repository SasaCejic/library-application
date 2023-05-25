/*
* This class performs tests for Book__c trigger 
*/
@isTest
public with sharing class BookTriggerTest {
    @isTest
    public static void onInsert_willAddError_whenAuthorPublisherNotAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);

        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookForTest, false);
        Test.stopTest();

        Assert.isTrue(insertResult.getErrors().size() == 1,'Errors should have been added to book record');
    }

    @isTest
    public static void onUpdate_willAddError_whenNewAuthorPublisherNotAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c oldAuthorForTest = testFactory.createAuthor(false);
        insert oldAuthorForTest;
        Author_Publisher__c authorPublisherForMock = testFactory
            .createAuthorPublisher(oldAuthorForTest.Id, publisherForTest.Id, false);
        insert authorPublisherForMock;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, oldAuthorForTest.Id, false);
        insert bookForTest;

        //Create new data for update
        Author__c newAuthorForTest = testFactory.createAuthor(false);
        bookForTest.Author__c=newAuthorForTest.Id;

        Test.startTest();
        Database.SaveResult updateResult = Database.update(bookForTest, false);
        Test.stopTest();

        Assert.isTrue(updateResult.getErrors().size() == 1,'Error should have been added to update result');
    }
}