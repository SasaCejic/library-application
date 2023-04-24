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
        //Create data for mocks and test
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = new TestFactory().createPublisher(publisherDetails, true);

        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'bookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1241353');
        Bookstore__c bookstoreForTest = new TestFactory().createBookstore(bookstoreDetails, true);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForTest = new TestFactory().createBook(publisherForTest.Id, bookDetails, true);

        Bookstore_Book__c bookstoreBookForTest = new TestFactory()
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false);  

        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookstoreBookForTest, false);
        Test.stopTest();

        System.assert(insertResult.isSuccess() == false);
    }
}
