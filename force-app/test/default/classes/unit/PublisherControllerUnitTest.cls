/*
* This class tests publisher controller methods
*/
@isTest
public with sharing class PublisherControllerUnitTest {
    @isTest
    public static void getPublishersNotWithBookstore_willUseService() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);

        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'bookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1241353');
        Bookstore__c bookstoreForTest = testFactory.createBookstore(bookstoreDetails, false, true);

        Mocker GetPublishersNotWithBookstoreServiceMock = new Mocker(GetPublishersNotWithBookstoreService.class)
        .setBehavior('getPublishers', null);
        GetPublishersNotWithBookstoreServiceMock.setBehavior('getResponse', new List<Publisher__c>{publisherForTest});

        ObjectFactory.mocks.put(
            GetPublishersNotWithBookstoreService.class.getName(),
            (GetPublishersNotWithBookstoreService) GetPublishersNotWithBookstoreServiceMock.getMock()
        );

        Test.startTest();
        List<Publisher__c> publishersNotWorkingWithBookstore = PublisherController.getPublishersNotWorkingWithBookstore(bookstoreForTest.Id);
        Test.stopTest();

        GetPublishersNotWithBookstoreServiceMock.assertMethodExecutionCount('getPublishers',1);
        GetPublishersNotWithBookstoreServiceMock.assertMethodExecutionCount('getResponse', 1);
    }
}