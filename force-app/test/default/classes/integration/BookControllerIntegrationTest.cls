/*
 * This class tests book controller methods
 */
@isTest
public with sharing class BookControllerIntegrationTest {
    @isTest
    public static void getBooksNotInBookstore_willReturnOneBook_IfNoBookstoreBooksRecordsAreCreated() {
        //disable triger unrelated to test
        BookTriggerHandler.triggerDisabled=true;

        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false);
        insert bookstoreForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;
        
        // execute
        Test.startTest();
        List<Book__c> booksNotInBookstore = BookController.getBooksNotInBookstore(bookstoreForTest.Id, 5);
        Test.stopTest();
        
        // assert
        Assert.areEqual(1, booksNotInBookstore.size());
    }

    @isTest
    public static void confirmDigitalBookPurchase_willSendMail_ifPurchaseIsInserted() {
        //disable triger unrelated to test
        BookPurchaseTriggerHandler.triggerDisabled = true;
        BookTriggerHandler.triggerDisabled = true;
        
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Book__c bookForTest = testFactory.createDigitalBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;

        //Execute
        Test.startTest();
        BookController.confirmDigitalBookPurchase('testaddress@gmail.com', 'testBook', 'testPrice', bookForTest.Id);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
 
        // assert
        Assert.areEqual(1, invocations);
    }
}