/*
* Class used for performing integration test for BookReviewTriggerTest
*/
@isTest
public with sharing class BookReviewTriggerTest {
    @isTest
    public static void onInsert_willNotAddError_ifNoSuchReviewExists() {
        //Create data for test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, true, false);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, bookDetails, true, false);

        Map<String, String> bookReviewDetails = new Map<String, String>();
        bookReviewDetails.put('name', 'Good Book');
        bookReviewDetails.put('rating', '4');
        Book_Review__c bookReviewForInsert = testFactory.createBookReview(bookForTest.Id, bookReviewDetails, true, false);
        
        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookReviewForInsert, false);
        Test.stopTest();

        System.assert(insertResult.isSuccess() == true);
    }
}