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
        BookTriggerHandler.triggerDisabled=true;
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, true, false);

        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'bookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1241353');
        Bookstore__c bookstoreForTest = testFactory.createBookstore(bookstoreDetails, true, false);

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

        Bookstore_Book__c bookstoreBookForTest = testFactory
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false, false);  

        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookstoreBookForTest, false);
        Test.stopTest();

        System.assert(insertResult.isSuccess() == false);
    }
}
