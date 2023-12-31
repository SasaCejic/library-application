/*
 * class used for testing service used for searching objects
*/
@isTest
public with sharing class ObjectSearchServiceTest {
    @isTest 
    public static void search_willReturnObject_ifRecordTypeIdIsNull() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;

        // execute
        Test.startTest();
        ObjectSearchService service = new ObjectSearchService();
        service.search('Publisher__c', null, '');
        Test.stopTest();

        // assert
        Assert.areEqual(1, service.getResponse().size());
    }

    @isTest 
    public static void search_WillReturnObject_ifRecordTypeIsNotNull() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false);
        insert bookstoreForTest;

        // execute
        Test.startTest();
        ObjectSearchService service = new ObjectSearchService();
        service.search('Bookstore__c', bookstoreForTest.RecordTypeId, '');
        Test.stopTest();

        // assert
        Assert.areEqual(1, service.getResponse().size());
    }

    @isTest
    public static void search_willUseCorrectSelector() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false);
        insert bookstoreForTest;

        // create mock
        Mocker objectSelectorMocker = new Mocker(ObjectSelector.class)
            .setBehavior('searchObjects', (List<SObject>) new List<Bookstore__c>{ bookstoreForTest });
        ObjectFactory.mocks.put(
            ObjectSelector.class.getName(),
            (ObjectSelector) objectSelectorMocker.getMock()
        );

        // execute
        ObjectSearchService service = new ObjectSearchService();
        service.search('Bookstore__c', bookstoreForTest.Id, '');

        // assert
        objectSelectorMocker.assertMethodExecutionCount('searchObjects', 1);
    }
}