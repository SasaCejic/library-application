/**
 * Class used to perform integration test for ObjectSearchController
*/
@isTest
public with sharing class ObjectSearchControllerIntegrationTest {
    @isTest
    public static void searchObject_willReturnPublisherRecords_ifRecordTypesAreNotIncludedInSearchAndSearchIsEmpty() {
        // create data for mock
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;

        // execute
        Test.startTest();
        List<SObject> searchedObjects = ObjectSearchController.searchObject('Publisher__c', null, '');
        Test.stopTest();
        
        // assert
        Assert.areEqual(1, searchedObjects.size());
    }

    @isTest
    public static void searchObject_willReturnBookstoreRecords_ifRecordTypesAreIncludedInSearchAndSearchIsEmpty() {
        // create data for mock
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false);
        insert bookstoreForTest;
        
        // execute
        Test.startTest();
        List<SObject> searchedObjects = ObjectSearchController.searchObject('Bookstore__c', bookstoreForTest.recordTypeId, '');
        Test.stopTest();

        // assert
        Assert.areEqual(1, searchedObjects.size());
    }
}