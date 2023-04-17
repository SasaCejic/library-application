/*
* This class performs tests for Bookstore_Publisher__c selectors
*/
@isTest
public with sharing class BookstorePublisherSelectorTest {
    @isTest
    public static void getBookstorePublisherByPublisherIdAndBookstoreId_willReturnBookstorePublisher() {
        List<Bookstore__c> bookstoreForInsert = new BookstoreTestFactory().createBookstores(1);
        insert bookstoreForInsert;
        List<Publisher__c> publisherForInsert = new PublisherTestFactory().createPublishers(1);
        insert publisherForInsert;
        List<Bookstore_Publisher__c> bkStorePublisherForInsert = new BookstorePublisherTestFactory()
        .createBookstorePublishers(1, publisherForInsert[0].Id,  bookstoreForInsert[0].Id);
        insert bkStorePublisherForInsert;

        Test.startTest();
        List<Bookstore_Publisher__c> bkStorePublishersForTest = new BookstorePublisherSelector()
        .getBookstorePublisherByPublisherIdAndBookstoreId(publisherForInsert[0].Id, bookstoreForInsert[0].Id);
        Test.stopTest();
        
        System.assertEquals(bkStorePublishersForTest[0].Id, bkStorePublisherForInsert[0].Id);
    }
}