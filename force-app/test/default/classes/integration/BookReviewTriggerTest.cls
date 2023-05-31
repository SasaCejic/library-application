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
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;

        // approve the book that was inserted because it is locked for edit
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setWorkitemId([SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :bookForTest.Id].Id);
        req.setAction('Approve');
        Approval.process(new List<Approval.ProcessWorkitemRequest>{ req });

        // create Book review record
        Book_Review__c bookReviewForInsert = testFactory.createBookReview(bookForTest.Id, false);

        // Run test as another user because of the validation rule
        User user = testFactory.createLibraryUser(false);
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