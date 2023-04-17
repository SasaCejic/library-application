/*
* This class performs integration tests for BookstoreBookValidationService class
*/
@isTest
public with sharing class BookstoreBookValidationIntegrationTest {
    /*
    * Method inserts the needed data so validation succeeds.
    * Book and bookstore have the same publisher, therefore validation is successfull
    * Method is ran as a bookstore manager, else the validation would not be performed at all
    */
    @isTest
    public static void validatePublisher_validationSuccessfull_willRunAsBookstoreManager() {
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
            bookstoreForTest[0].Manager__c = u.Id;
            insert bookstoreForTest;
            List<Book__c> bookForTest = new BookTestFactory().createBooks(1, publisherForTest[0].Id);
            insert bookForTest;
            List<Bookstore_Publisher__c> bkStorePublisherForTest = new BookstorePublisherTestFactory()
            .createBookstorePublishers(1, publisherForTest[0].Id, bookstoreForTest[0].Id);
            insert bkStorePublisherForTest;
            List<Bookstore_Book__c> bkstoreBookForTest = new BookstoreBookTestFactory()
            .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);

            Test.startTest();
            BookstoreBookValidationService bkStoreBookValidation = new BookstoreBookValidationService();
            bkStoreBookValidation.validatePublisher(bkstoreBookForTest);
            Test.stopTest();
            System.assert(bkstoreBookForTest[0].getErrors().size() == 0);
        }
    }
    /*
    * Method inserts the data so validation fails.
    * Book and bookstore do not have the same publishers, that was achieved by not 
    inserting Bookstore_Publisher__c object
    * Method is ran as Bookstore Manager, else the validation would not be performed.
    */
    @isTest
    public static void validatePublisher_validationFailure_willRunAsBookstoreManager() {
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
            BookstoreBookValidationService bkstoreBookValidation = new BookstoreBookValidationService();
            bkstoreBookValidation.validatePublisher(bkstoreBookForTest);
            Test.stopTest();

            System.assert(bkstoreBookForTest[0].getErrors().size() > 0);
            System.assertEquals(bkstoreBookForTest[0].getErrors()[0].getMessage(),'Book and bookstore must work with the same publisher!');
        }
    }
    /*
    * Method shows that validation will not be performed if the user isn't Book Manager
    */
    @isTest
    public static void validatePublisher_validationNotPerformed_willNotRunAsBookstoreManager() {
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
            BookstoreBookValidationService bkstoreBookValidation = new BookstoreBookValidationService();
            bkstoreBookValidation.validatePublisher(bkstoreBookForTest);
            Test.stopTest();
            
            System.assert(bkstoreBookForTest[0].getErrors().size() == 0);
        }
    }
}