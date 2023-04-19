/*
* This class performs tests for Bookstore_Publisher__c selectors
*/
@isTest
public with sharing class BookstorePublisherSelectorTest {
    @isTest
    public static void getBookstorePublisherByPublisherIdAndBookstoreId_willReturnBookstorePublisher() {
        List<Bookstore__c> bookstoreForInsert = new TestFactory().createBookstores(1);
        insert bookstoreForInsert;
        List<Publisher__c> publisherForInsert = new TestFactory().createPublishers(1);
        insert publisherForInsert;
        List<Bookstore_Publisher__c> bkStorePublisherForInsert = new TestFactory()
        .createBookstorePublishers(1, publisherForInsert[0].Id,  bookstoreForInsert[0].Id);
        insert bkStorePublisherForInsert;
        Test.startTest();
        List<Bookstore_Publisher__c> bkStorePublishersForTest = new BookstorePublisherSelector()
        .getBookstorePublishersWithPublisherAndBookstoreId(new List<List<Id>>{new List<Id>{publisherForInsert[0].Id, bookstoreForInsert[0].Id}});
        Test.stopTest();
        
        System.assertEquals(bkStorePublishersForTest[0].Id, bkStorePublisherForInsert[0].Id);
    }
}