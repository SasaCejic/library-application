/**
 * Class used for unit tests for BookstoreBookController
 */
@isTest
public with sharing class BookstoreBookControllerTest {
    @isTest
    public static void returnBookstoreBooksCausingErrorOnPublisherDelete_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Id BookstorePublisherId = testFactory.getFakeId(Bookstore_Publisher__c.SObjectType, true);

        // create mock
        Mocker GetBookstoreBookOnPublsherDeleteServiceMocker = new Mocker(GetBookstoreBookOnPublsherDeleteService.class);
        GetBookstoreBookOnPublsherDeleteServiceMocker.setBehavior('getBookstoreBooks', null);
        GetBookstoreBookOnPublsherDeleteServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            GetBookstoreBookOnPublsherDeleteService.class.getName(),
            (GetBookstoreBookOnPublsherDeleteService) GetBookstoreBookOnPublsherDeleteServiceMocker.getMock()
        );

        // execute
        BookstoreBookController.returnBookstoreBooksCausingErrorOnPublisherDelete(BookstorePublisherId, 5);

        // assert
        GetBookstoreBookOnPublsherDeleteServiceMocker.assertMethodExecutionCount('getBookstoreBooks', 1);
        GetBookstoreBookOnPublsherDeleteServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }
}