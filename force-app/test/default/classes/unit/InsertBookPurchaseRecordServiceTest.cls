/*
 * Class used for testng book purchase insert service
 */
@isTest
public with sharing class InsertBookPurchaseRecordServiceTest {
    @isTest
    public static void insertPurchase_willInsert_ifBookIdIsValid() {
        // disable triger unrelated to test
        BookTriggerHandler.triggerDisabled = true;
        BookPurchaseTriggerHandler.triggerDisabled = true;

        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, true, false);
        
        // execute
        Test.startTest();
        InsertBookPurchaseRecordService service = new InsertBookPurchaseRecordService();
        service.insertPurchase(bookForTest.Id);
        Test.stopTest();

        // assert
        Assert.areEqual(true, service.getResponse().isSuccess());
    }
}