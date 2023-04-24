/*
* This class performs tests for Bookstore_Publisher__c selectors
*/
@isTest
public with sharing class BookstorePublisherSelectorTest {
    @isTest
    public static void getBookstorePublisherByPublisherIdAndBookstoreId_willReturnFiveBookstorePublishers_ifFiveBookstorePublishersInserted() {
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
        Bookstore_Publisher__c bookStorePublisherForInsert = new TestFactory()
        .createBookstorePublisher(publisherForTest.Id,  bookstoreForTest.Id, true);

        Test.startTest();
        List<Bookstore_Publisher__c> bookStorePublishersForTest = new BookstorePublisherSelector()
        .getAllBookstorePublishers();
        Test.stopTest();
        
        System.assertEquals(bookStorePublishersForTest[0].Id, bookStorePublisherForInsert.Id);
        System.assertEquals(bookStorePublishersForTest.size(), 1);
    }
}