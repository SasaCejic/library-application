/**
 * Class used for testing Author_Publisher__c Trigger
 */
@isTest
public with sharing class AuthorPublisherTriggerIntegrationTest {
    @isTest
    public static void onDelete_willAddError_ifRelatedBookExists() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, false);
        insert authorPublisherForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;

        // execute
        Test.startTest();
        Database.DeleteResult deleteResult = Database.delete(AuthorPublisherForTest, false);
        Test.stopTest();

        // assert
        Assert.areEqual(false, deleteResult.isSuccess());
    }
}