/*
 * Class used for performing integration test for BookPurchaseTrigger
 */
@isTest
public with sharing class BookPurchaseTriggerTest {
    @isTest
    public static void onInsert_willNotAddError_ifNoSuchPurchaseExists() {
        // disable triger unrelated to test
        BookTriggerHandler.triggerDisabled = true;
        
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, true, false);
        Book_Purchase__c purchaseForTest = testFactory.createBookPurchase(bookForTest.Id, false, false);
        
        // execute
        Test.startTest();
        Database.SaveResult insertResult = Database.insert(purchaseForTest, false);
        Test.stopTest();

        // assert 
        Assert.isTrue(insertResult.isSuccess() == true);
    }
}