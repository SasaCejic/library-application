/**
 * Class used for performing unit tests for BookRestApi
 */
@isTest
public with sharing class BookRestApiTest {
    @isTest
    public static void doPost_willUseService() {
        // create mock
        Mocker BookRestApiPostRequestServiceMocker = new Mocker(BookRestApiPostRequestService.class)
            .setBehavior('insertBooks', null);
        ObjectFactory.mocks.put(
            BookRestApiPostRequestService.class.getName(),
            (BookRestApiPostRequestService) BookRestApiPostRequestServiceMocker.getMock()
        );

        // execute
        BookRestapi.doPost();

        // assert
        BookRestApiPostRequestServiceMocker.assertMethodExecutionCount('insertBooks', 1);
    }
}