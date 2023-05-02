/*
 * Class used for performing integration test for BookReviewTriggerTest
 */
@isTest
public with sharing class BookReviewTriggerTest {
    @isTest
    public static void onInsert_willNotAddError_ifNoSuchReviewExists() {
        // disable triger unrelated to test
        BookTriggerHandler.triggerDisabled = true;
        
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, true, false);
        Book_Review__c bookReviewForInsert = testFactory.createBookReview(bookForTest.Id, false, false);
        
        // Run test as another user because of the validation rule
        User user = testFactory.createLibraryUser();
        system.runAs(user) {
             // execute
            Test.startTest();
            Database.SaveResult insertResult = Database.insert(bookReviewForInsert, false);
            Test.stopTest();

            // assert
            Assert.isTrue(insertResult.isSuccess() == true);
        }
    }
}