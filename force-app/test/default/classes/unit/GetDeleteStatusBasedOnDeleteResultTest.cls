/**
 * Class used for testing GetDeleteStatudBasedOnDeleteResultService used for BookstorePublisher Controller
 * @see BookstorePublisherVFController
 * Database.DeleteResult can't be instantiated so Custom Json and type casting was used
 */
@isTest
public with sharing class GetDeleteStatusBasedOnDeleteResultTest {
    @isTest
    public static void getStatus_willReturnFalse_ifDeleteResultIsNull() {
        // execute
        GetDeletStatusBasedOnDeleteResultService service = new GetDeletStatusBasedOnDeleteResultService();
        service.getStatus(null);

        // assert
        Assert.isFalse(service.getResponse());
    }

    @isTest
    public static void getStatus_willReturnTrue_ifDeleteResultIsNotSuccessfull() {
        // create fake Database.DeleteResult 
        Database.DeleteResult deleteResult = (Database.DeleteResult) JSON.deserialize('{"success":false,"id":"0013000000abcde"}', Database.DeleteResult.class);

        // execute
        GetDeletStatusBasedOnDeleteResultService service = new GetDeletStatusBasedOnDeleteResultService();
        service.getStatus(deleteResult);

        // assert
        Assert.isTrue(service.getResponse());
    }

    @isTest
    public static void getStatus_willReturnFalse_ifDeleteResultIsSuccessfull() {
        // create fake Database.DeleteResult 
        Database.DeleteResult deleteResult = (Database.DeleteResult) JSON.deserialize('{"success":true,"id":"0013000000abcde"}', Database.DeleteResult.class);

        // execute
        GetDeletStatusBasedOnDeleteResultService service = new GetDeletStatusBasedOnDeleteResultService();
        service.getStatus(deleteResult);

        // assert
        Assert.isFalse(service.getResponse());
    }
}