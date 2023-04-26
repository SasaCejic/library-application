/*
* This class performs tests for Bookstore_Publisher__c selectors
*/
@isTest
public with sharing class AuthorPublisherSelectorTest {
    @isTest
    public static void getList_willReturnAuthorPublishers_ifAnyAuthorPublishersInserted() {
        //Create data for mocks and test
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

        Author_Publisher__c authorPublisherForInsert = testFactory
        .createAuthorPublisher(authorForTest.Id,  publisherForTest.Id, true, false);

        Test.startTest();
        List<Author_Publisher__c> authorPublishersForTest = new AuthorPublisherSelector()
        .getList();
        Test.stopTest();
        
        System.assertEquals(authorPublishersForTest[0].Id, authorPublisherForInsert.Id);
        System.assertEquals(authorPublishersForTest.size(), 1);
    }
}