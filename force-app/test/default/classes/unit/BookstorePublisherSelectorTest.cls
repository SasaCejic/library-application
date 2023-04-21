/*
* This class performs tests for Bookstore_Publisher__c selectors
*/
@isTest
public with sharing class BookstorePublisherSelectorTest {
    @isTest
    public static void getBookstorePublisherByPublisherIdAndBookstoreId_willReturnFiveBookstorePublishers_ifFiveBookstorePublishersInserted() {
        List<Bookstore__c> bookstoreForInsert = new TestFactory().createBookstores(1);
        insert bookstoreForInsert;
        List<Publisher__c> publisherForInsert = new TestFactory().createPublishers(1);
        insert publisherForInsert;
        List<Bookstore_Publisher__c> bkStorePublisherForInsert = new TestFactory()
        .createBookstorePublishers(5, publisherForInsert[0].Id,  bookstoreForInsert[0].Id);
        insert bkStorePublisherForInsert;

        Test.startTest();
        List<Bookstore_Publisher__c> bkStorePublishersForTest = new BookstorePublisherSelector()
        .getAllBookstorePublishers();
        Test.stopTest();
        
        System.assertEquals(bkStorePublishersForTest[0].Id, bkStorePublisherForInsert[0].Id);
        System.assertEquals(bkStorEPublishersForTest.size(), bkStorePublisherForInsert.size());
    }
}