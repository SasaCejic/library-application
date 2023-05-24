/**
 * Class used for performing unit tests for BookRestApiPostRequestService
 */
@isTest
public with sharing class BookRestApiPostRequestServiceTest {
    @isTest
    public static void insertBooks_willFailWithStatus400_ifDataWasntProvidedInHttpRequest() {
        // create data
        BookRestApiRequestDTO bookRestApiRequestDto = new BookRestApiRequestDTO();
        bookRestApiRequestDto.bookList = new List<Book__c>{};
        bookRestApiRequestDto.insertOption = 1;

        // create mock
        Mocker ConvertBookRestApiJsonDataServiceMocker = new Mocker(ConvertBookRestApiJsonDataService.class)
            .setBehavior('convert', bookRestApiRequestDto);
        ObjectFactory.mocks.put(
            ConvertBookRestApiJsonDataService.class.getName(),
            (ConvertBookRestApiJsonDataService) ConvertBookRestApiJsonDataServiceMocker.getMock()
        );

        // Set up the REST Request so service wont try to dereferene null
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(JSON.serialize(new Map<String, Object>()));
        RestContext.request = request;
        // Set up the REST response so we can see what would the result of the service be
        RestResponse response = new RestResponse();
        RestContext.response = response;

        // execute
        BookRestApiPostRequestService service = new BookRestApiPostRequestService();
        service.insertBooks();

        // assert
        Assert.areEqual(400, response.statusCode);        
    }

    @isTest
    public static void insertBooks_willFailWithStatus400_ifOptionWasntProvidedInHttpRequest() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        List<Book__c> bookListForTest = new List<Book__c>();
        bookListForTest.add(testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true));
        
        BookRestApiRequestDTO bookRestApiRequestDto = new BookRestApiRequestDTO();
        bookRestApiRequestDto.bookList = bookListForTest;
        bookRestApiRequestDto.insertOption = null;

        // create mock
        Mocker ConvertBookRestApiJsonDataServiceMocker = new Mocker(ConvertBookRestApiJsonDataService.class)
            .setBehavior('convert', bookRestApiRequestDto);
        ObjectFactory.mocks.put(
            ConvertBookRestApiJsonDataService.class.getName(),
            (ConvertBookRestApiJsonDataService) ConvertBookRestApiJsonDataServiceMocker.getMock()
        );

        // Set up the REST Request so service wont try to dereferene null
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(JSON.serialize(new Map<String, Object>()));
        RestContext.request = request;
        // Set up the REST response so we can see what would the result of the service be
        RestResponse response = new RestResponse();
        RestContext.response = response;

        // execute
        BookRestApiPostRequestService service = new BookRestApiPostRequestService();
        service.insertBooks();

        // assert
        Assert.areEqual(400, response.statusCode);
    }

    @isTest
    public static void insertBooks_willFailWithStatus409_ifThereAreBookDuplicatesAndInsertOptionIs2() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        List<Book__c> booksForTest = new List<Book__c>{};
        booksForTest.add(testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, false));

        BookRestApiRequestDTO bookRestApiRequestDto = new BookRestApiRequestDTO();
        bookRestApiRequestDto.bookList = booksForTest;
        bookRestApiRequestDto.insertOption = 2;

        Map<String, List<Book__c>> duplicateRecordsMap = new Map<String, List<Book__c>>();
        duplicateRecordsMap.put('nonDuplicateRecords', booksForTest);
        duplicateRecordsMap.put('duplicatesFromDatabase', booksForTest);
        duplicateRecordsMap.put('duplicateRecords', booksForTest);

        // create mocks
        Mocker ConvertBookRestApiJsonDataServiceMocker = new Mocker(ConvertBookRestApiJsonDataService.class)
            .setBehavior('convert', bookRestApiRequestDto);
        ObjectFactory.mocks.put(
            ConvertBookRestApiJsonDataService.class.getName(),
            (ConvertBookRestApiJsonDataService) ConvertBookRestApiJsonDataServiceMocker.getMock()
        );

        Mocker GetDuplicateBooksServiceMocker = new Mocker(GetDuplicateBooksService.class)
            .setBehavior('getDuplicates', duplicateRecordsMap);
        ObjectFactory.mocks.put(
            GetDuplicateBooksService.class.getName(),
            (GetDuplicateBooksService) GetDuplicateBooksServiceMocker.getMock()
        );

        Mocker InsertBookRecordServiceMocker = new Mocker(InsertBookRecordService.class)
            .setBehavior('insertBooks', null);
        ObjectFactory.mocks.put(
            InsertBookRecordService.class.getName(),
            (InsertBookRecordService) InsertBookRecordServiceMocker.getMock()
        );

        // Set up the REST Request so service wont try to dereferene null
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(JSON.serialize(new Map<String, Object>()));
        RestContext.request = request;
        // Set up the REST response so we can see what would the result of the service be
        RestResponse response = new RestResponse();
        RestContext.response = response;

        // execute
        BookRestApiPostRequestService service = new BookRestApiPostRequestService();
        service.insertBooks();

        // assert
        Assert.areEqual(409, response.statusCode);
    }
    
    @isTest
    public static void insertBooks_willFailWithStatus409_ifThereAreBookDuplicatesAndOptionIs1() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        List<Book__c> booksForTest = new List<Book__c>{};
        booksForTest.add(testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, false));

        BookRestApiRequestDTO bookRestApiRequestDto = new BookRestApiRequestDTO();
        bookRestApiRequestDto.bookList = booksForTest;
        bookRestApiRequestDto.insertOption = 1;

        Map<String, List<Book__c>> duplicateRecordsMap = new Map<String, List<Book__c>>();
        duplicateRecordsMap.put('nonDuplicateRecords', booksForTest);
        duplicateRecordsMap.put('duplicatesFromDatabase', booksForTest);
        duplicateRecordsMap.put('duplicateRecords', booksForTest);

        // create mocks
        Mocker ConvertBookRestApiJsonDataServiceMocker = new Mocker(ConvertBookRestApiJsonDataService.class)
            .setBehavior('convert', bookRestApiRequestDto);
        ObjectFactory.mocks.put(
            ConvertBookRestApiJsonDataService.class.getName(),
            (ConvertBookRestApiJsonDataService) ConvertBookRestApiJsonDataServiceMocker.getMock()
        );

        Mocker GetDuplicateBooksServiceMocker = new Mocker(GetDuplicateBooksService.class)
            .setBehavior('getDuplicates', duplicateRecordsMap);
        ObjectFactory.mocks.put(
            GetDuplicateBooksService.class.getName(),
            (GetDuplicateBooksService) GetDuplicateBooksServiceMocker.getMock()
        );

        Mocker InsertBookRecordServiceMocker = new Mocker(InsertBookRecordService.class)
            .setBehavior('insertBooks', null);
        ObjectFactory.mocks.put(
            InsertBookRecordService.class.getName(),
            (InsertBookRecordService) InsertBookRecordServiceMocker.getMock()
        );


        // Set up the REST Request so service wont try to dereferene null
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(JSON.serialize(new Map<String, Object>()));
        RestContext.request = request;
        // Set up the REST response so we can see what would the result of the service be
        RestResponse response = new RestResponse();
        RestContext.response = response;

        // execute
        BookRestApiPostRequestService service = new BookRestApiPostRequestService();
        service.insertBooks();

        // assert
        Assert.areEqual(409, response.statusCode);
    }

    @isTest
    public static void insertBooks_willSucceedWithStatusCode200_ifThereAreNoDuplicates() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        List<Book__c> booksForTest = new List<Book__c>{};
        booksForTest.add(testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, false));

        BookRestApiRequestDTO bookRestApiRequestDto = new BookRestApiRequestDTO();
        bookRestApiRequestDto.bookList = booksForTest;
        bookRestApiRequestDto.insertOption = 2;

        Map<String, List<Book__c>> duplicateRecordsMap = new Map<String, List<Book__c>>();
        duplicateRecordsMap.put('nonDuplicateRecords', booksForTest);
        duplicateRecordsMap.put('duplicatesFromDatabase', new List<Book__c> {});
        duplicateRecordsMap.put('duplicateRecords', new List<Book__c>{});

        // create mocks
        Mocker ConvertBookRestApiJsonDataServiceMocker = new Mocker(ConvertBookRestApiJsonDataService.class)
            .setBehavior('convert', bookRestApiRequestDto);
        ObjectFactory.mocks.put(
            ConvertBookRestApiJsonDataService.class.getName(),
            (ConvertBookRestApiJsonDataService) ConvertBookRestApiJsonDataServiceMocker.getMock()
        );

        Mocker GetDuplicateBooksServiceMocker = new Mocker(GetDuplicateBooksService.class)
            .setBehavior('getDuplicates', duplicateRecordsMap);
        ObjectFactory.mocks.put(
            GetDuplicateBooksService.class.getName(),
            (GetDuplicateBooksService) GetDuplicateBooksServiceMocker.getMock()
        );

        Mocker InsertBookRecordServiceMocker = new Mocker(InsertBookRecordService.class)
            .setBehavior('insertBooks', null);
        ObjectFactory.mocks.put(
            InsertBookRecordService.class.getName(),
            (InsertBookRecordService) InsertBookRecordServiceMocker.getMock()
        );

        // Set up the REST Request so service wont try to dereferene null
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(JSON.serialize(new Map<String, Object>()));
        RestContext.request = request;
        // Set up the REST response so we can see what would the result of the service be
        RestResponse response = new RestResponse();
        RestContext.response = response;

        // execute
        BookRestApiPostRequestService service = new BookRestApiPostRequestService();
        service.insertBooks();

        // assert
        Assert.areEqual(200, response.statusCode);
    }

    @isTest
    public static void insertBooks_willUseServices() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        List<Book__c> booksForTest = new List<Book__c>{};
        booksForTest.add(testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, false));

        BookRestApiRequestDTO bookRestApiRequestDto = new BookRestApiRequestDTO();
        bookRestApiRequestDto.bookList = booksForTest;
        bookRestApiRequestDto.insertOption = 2;

        Map<String, List<Book__c>> duplicateRecordsMap = new Map<String, List<Book__c>>();
        duplicateRecordsMap.put('nonDuplicateRecords', booksForTest);
        duplicateRecordsMap.put('duplicatesFromDatabase', new List<Book__c> {});
        duplicateRecordsMap.put('duplicateRecords', new List<Book__c>{});

        // create mocks
        Mocker ConvertBookRestApiJsonDataServiceMocker = new Mocker(ConvertBookRestApiJsonDataService.class)
            .setBehavior('convert', bookRestApiRequestDto);
        ObjectFactory.mocks.put(
            ConvertBookRestApiJsonDataService.class.getName(),
            (ConvertBookRestApiJsonDataService) ConvertBookRestApiJsonDataServiceMocker.getMock()
        );

        Mocker GetDuplicateBooksServiceMocker = new Mocker(GetDuplicateBooksService.class)
            .setBehavior('getDuplicates', duplicateRecordsMap);
        ObjectFactory.mocks.put(
            GetDuplicateBooksService.class.getName(),
            (GetDuplicateBooksService) GetDuplicateBooksServiceMocker.getMock()
        );

        Mocker InsertBookRecordServiceMocker = new Mocker(InsertBookRecordService.class)
            .setBehavior('insertBooks', null);
        ObjectFactory.mocks.put(
            InsertBookRecordService.class.getName(),
            (InsertBookRecordService) InsertBookRecordServiceMocker.getMock()
        );

        // Set up the REST Request so service wont try to dereferene null
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(JSON.serialize(new Map<String, Object>()));
        RestContext.request = request;
        // Set up the REST response so we can see what would the result of the service be
        RestResponse response = new RestResponse();
        RestContext.response = response;

        // execute
        BookRestApiPostRequestService service = new BookRestApiPostRequestService();
        service.insertBooks();

        // assert
        ConvertBookRestApiJsonDataServiceMocker.assertMethodExecutionCount('convert', 1);
        GetDuplicateBooksServiceMocker.assertMethodExecutionCount('getDuplicates', 1);
        InsertBookRecordServiceMocker.assertMethodExecutionCount('insertBooks', 1);
    }
}