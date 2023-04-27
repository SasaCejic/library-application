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

        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('firstName', 'Author');
        authorDetails.put('lastName', 'Author');
        Author__c authorForTest = testFactory.createAuthor(authorDetails, true, false);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, true, false);

        Map<String, String> bookReviewDetails = new Map<String, String>();
        bookReviewDetails.put('name', 'Good Book');
        bookReviewDetails.put('rating', '4');
        Book_Review__c bookReviewForInsert = testFactory.createBookReview(bookForTest.Id, bookReviewDetails, false, false);
        
        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookReviewForInsert, false);
        Test.stopTest();

        System.assert(insertResult.isSuccess() == true);
    }
}