/**
 * Class used for performing unit tests for BookRestApi
 */
@isTest
public with sharing class BookRestApiTest {
    @isTest
    public static void doPost_willUseService() {
        // create data
        InsertBooksPostRequestResponseDTO dto =  new InsertBooksPostRequestResponseDTO();
        dto.statusCode = 200;

        // set Rest response so we don't get error when setting header
        RestResponse response = new RestResponse();
        RestContext.response = response;

        // create mock
        Mocker InsertBooksPostRequestServiceMocker = new Mocker(InsertBooksPostRequestService.class);
        InsertBooksPostRequestServiceMocker.setBehavior('insertBooks', null);
        InsertBooksPostRequestServiceMocker.setBehavior('getResponse', dto);
        ObjectFactory.mocks.put(
            InsertBooksPostRequestService.class.getName(),
            (InsertBooksPostRequestService) InsertBooksPostRequestServiceMocker.getMock()
        );

        // execute
        BookRestapi.doPost();

        // assert
        InsertBooksPostRequestServiceMocker.assertMethodExecutionCount('insertBooks', 1);
    }
}