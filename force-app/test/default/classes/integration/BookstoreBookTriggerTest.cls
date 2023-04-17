/*
* This class performs tests for Bookstore_Book__c trigger
*/
@isTest
public with sharing class BookstoreBookTriggerTest {
    /*
    * Method performs successfull Publisher validation because it is ran as Book Manager
    */
    @isTest
    public static void testTriggerOnInsert_willPerformPublisherValidation() {
        // create a user with the necessary profile
        Profile p = [SELECT Id FROM Profile WHERE Name='Library User'];
        User u = new User(Alias = 'testuser', Email='testuser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', 
            UserName='testuser@testorg.com');
        insert u;
        // assign the Bookstore_Manager permission set to the user
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Bookstore_Manager'];
        PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);
        insert psa;
        
        System.runAs(u) {
            List<Publisher__c> publisherForTest = new PublisherTestFactory().createPublishers(1);
            insert publisherForTest;
            List<Bookstore__c> bookstoreForTest = new BookstoreTestFactory().createBookstores(1);
            insert bookstoreForTest;
            List<Book__c> bookForTest = new BookTestFactory().createBooks(1, publisherForTest[0].Id);
            insert bookForTest;
            List<Bookstore_Book__c> bkstoreBookForTest = new BookstoreBookTestFactory()
            .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);  

            Test.startTest();
            Database.SaveResult[] insertResult = Database.insert(bkstoreBookForTest, false);
            Test.stopTest();

            System.assert(insertResult[0].isSuccess() == false);
        }
    }
    /*
    * Method does not perform Publisher validation because it is not run as Book Manager
    */
    @isTest
    public static void testTriggerOnInsert_willNotPerformPublisherValidation() {
        // create a user with the necessary profile
        Profile p = [SELECT Id FROM Profile WHERE Name='Library User'];
        User u = new User(Alias = 'testuser', Email='testuser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', 
            UserName='testuser@testorg.com');
        insert u;

        System.runAs(u) {
            List<Publisher__c> publisherForTest = new PublisherTestFactory().createPublishers(1);
            insert publisherForTest;
            List<Bookstore__c> bookstoreForTest = new BookstoreTestFactory().createBookstores(1);
            insert bookstoreForTest;
            List<Book__c> bookForTest = new BookTestFactory().createBooks(1, publisherForTest[0].Id);
            insert bookForTest;
            List<Bookstore_Book__c> bkstoreBookForTest = new BookstoreBookTestFactory()
            .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);  

            Test.startTest();
            Database.SaveResult[] insertResult = Database.insert(bkstoreBookForTest, false);
            Test.stopTest();
            
            System.assert(insertResult[0].isSuccess() == true);
        }
    }
}
