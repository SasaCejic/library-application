/*
* This class performs tests for Author__c trigger 
*/
@isTest
public with sharing class AuthorTriggerTest {
    @isTest
    public static void onUpdate_willAddError_whenStdAuthorsChanged() {
        //Create data
        TestFactory testFactory = new TestFactory();
        Author__c anonAuthor = testFactory.createAuthor(false);
        insert anonAuthor;
        Author__c unknownAuthor = testFactory.createAuthor(false);
        insert unknownAuthor;
        anonAuthor.First_Name__c = 'Changed';
        Standard_Authors_Settting__c stdAuthorSetting = testFactory
            .createStandardAuthorsSettting(anonAuthor.Id, unknownAuthor.Id, false);
        insert stdAuthorSetting;

        // execute
        Test.startTest();
        Database.SaveResult updateResult = Database.update(anonAuthor, false);
        Test.stopTest();

        // assert
        Assert.isTrue(updateResult.getErrors().size() == 1,'An error should have been added to update result');
    }

    @isTest
    public static void onDelete_willNotAddError_whenStdAuthorsNotDeleted() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Author__c anonAuthor= testFactory.createAuthor(false);
        insert anonAuthor;
        Author__c unknownAuthor= testFactory.createAuthor(false);
        insert unknownAuthor;
        Author__c authorForDelete= testFactory.createAuthor(false);
        insert authorForDelete;
        Standard_Authors_Settting__c stdAuthorSetting = testFactory
            .createStandardAuthorsSettting(anonAuthor.Id, unknownAuthor.Id, false);
        insert stdAuthorSetting;

        // execute
        Test.startTest();
        Database.DeleteResult deleteResult = Database.delete(authorForDelete);
        Test.stopTest();

        // assert
        Assert.isTrue(deleteResult.getErrors().size() == 0,'Errors should not have been added to delete result');
    }
}