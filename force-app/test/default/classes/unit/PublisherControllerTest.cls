/*
 * This class tests publisher controller methods
 */
@isTest
public with sharing class PublisherControllerTest {
    @isTest
    public static void getPublishersNotWithBookstore_willUseService() {
        // create mock
        Mocker GetPublishersNotWithBookstoreServiceMock = new Mocker(GetPublishersNotWithBookstoreService.class)
        .setBehavior('getPublishers', null);
        GetPublishersNotWithBookstoreServiceMock.setBehavior('getResponse', new List<Publisher__c>{});
        GetPublishersNotWithBookstoreServiceMock.setBehavior('getPublishers', null);
        ObjectFactory.mocks.put(
            GetPublishersNotWithBookstoreService.class.getName(),
            (GetPublishersNotWithBookstoreService) GetPublishersNotWithBookstoreServiceMock.getMock()
        );
        
        // execute
        List<Publisher__c> publishersNotWorkingWithBookstore = PublisherController.getPublishersNotWorkingWithBookstore(new TestFactory().getFakeId(Publisher__c.SObjectType, true), 5);

        // assert
        GetPublishersNotWithBookstoreServiceMock.assertMethodExecutionCount('getPublishers',1);
        GetPublishersNotWithBookstoreServiceMock.assertMethodExecutionCount('getResponse', 1);
    }
}