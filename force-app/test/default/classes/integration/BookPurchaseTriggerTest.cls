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
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;
        Book_Purchase__c purchaseForTest = testFactory.createBookPurchase(bookForTest.Id, false);

        // execute
        Test.startTest();
        Database.SaveResult insertResult = Database.insert(purchaseForTest, false);
        Test.stopTest();

        // assert 
        Assert.isTrue(insertResult.isSuccess() == true);
    }
}