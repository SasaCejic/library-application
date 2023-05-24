/*
 * This class is used for testing book search service
 * There will be 1 positive, 2 negative and 2 mockerexecutioncount tests
 */
@IsTest
public with sharing class BookSearchServiceTest {
    @IsTest
    static void getBooksFromSearchDTO_IfReviewScoreSet_WillUseBothSelectors() {
        // create mock
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getListFromQueryConditions', new List<Book__c>{});
        // set mock
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMock.getMock()
        );

        //create mock
        Mocker bookReviewSelectorMock = new Mocker(BookReviewSelector.class)
            .setBehavior('getAverageRatingListByBookIdSet', new List<AggregateResult>{});
        // set mock
        ObjectFactory.mocks.put(
            BookReviewSelector.class.getName(),
            (BookReviewSelector) bookReviewSelectorMock.getMock()
        );

        //create data
        BookSearchDTO bookDTO = new TestFactory().createBookSearchDTO(null, null, null);

        // execute
        Test.startTest();
        BookSearchService service = new BookSearchService();
        service.getBooksFromSearchDTO(bookDTO, 1, 1 );
        List<Book__c> books = service.getResponse();
        Test.stopTest();

        // assert
        bookSelectorMock.assertMethodExecutionCount('getListFromQueryConditions', 1);
        bookReviewSelectorMock.assertMethodExecutionCount('getAverageRatingListByBookIdSet', 1);
    }

    @IsTest
    static void getBooksFromSearchDTO_IfReviewScoreNotSet_WillNotUseReviewSelector() {
        // create mock
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getListFromQueryConditions', new List<Book__c>{});
        // set mock
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMock.getMock()
        );

        //create mock
        Mocker bookReviewSelectorMock = new Mocker(BookReviewSelector.class)
            .setBehavior('getAverageRatingListByBookIdSet', new List<AggregateResult>{});
        // set mock
        ObjectFactory.mocks.put(
            BookReviewSelector.class.getName(),
            (BookReviewSelector) bookReviewSelectorMock.getMock()
        );

        // execute
        Test.startTest();
        BookSearchService service = new BookSearchService();
        service.getBooksFromSearchDTO(new BookSearchDTO(), 1, 1 );
        List<Book__c> books = service.getResponse();
        Test.stopTest();

        // assert
        bookSelectorMock.assertMethodExecutionCount('getListFromQueryConditions', 1);
        bookReviewSelectorMock.assertMethodExecutionCount('getAverageRatingListByBookIdSet', 0);
    }

    @IsTest
    static void getBooksFromSearchDTO_IfBookSearchDTONull_WillSetResponseToNull() {
        // create mock
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getListFromQueryConditions', new List<Book__c>{});
        // set mock
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMock.getMock()
        );

        //create mock
        Mocker bookReviewSelectorMock = new Mocker(BookReviewSelector.class)
            .setBehavior('getAverageRatingListByBookIdSet', new List<AggregateResult>{});
        // set mock
        ObjectFactory.mocks.put(
            BookReviewSelector.class.getName(),
            (BookReviewSelector) bookReviewSelectorMock.getMock()
        );

        // execute
        Test.startTest();
        BookSearchService service = new BookSearchService();
        service.getBooksFromSearchDTO(null, 1, 1 );
        List<Book__c> books = service.getResponse();
        Test.stopTest();

        // assert
        Assert.areEqual(null, books, 'Service should have null response value');
    }

    @IsTest
    static void getBooksFromSearchDTO_IfAllSearchParametersSetAndNoMatches_WillSetResponseToEmptyBookList() {
        // create testFactory
        TestFactory testFactory = new TestFactory();

        //create and insert Author__c object
        Author__c author = testFactory.createAuthor(false, true);

        // create and insert Publisher__c object
        Publisher__c publisher = testFactory.createPublisher(false, true);

        //create and insert Book__c object
        Book__c book = testFactory.createBook(publisher.Id, author.Id, false, true);

        //create and insert Bookstore__c objects
        Bookstore__c bookstore = testFactory.createBookstore(false, true);

        //create Bookstore_Publisher__c junction object
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false, true);

        //create Bookstore_Book__c junction object
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false, true);

        //create BookSearchDTO
        BookSearchDTO bookDTO = new TestFactory().createBookSearchDTO(author.Id, publisher.Id, bookstore.Id);

        // create mock
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getListFromQueryConditions', new List<Book__c>{book});
        // set mock
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMock.getMock()
        );

        //create mock
        Mocker bookReviewSelectorMock = new Mocker(BookReviewSelector.class)
            .setBehavior('getAverageRatingListByBookIdSet', new List<AggregateResult>{});
        // set mock
        ObjectFactory.mocks.put(
            BookReviewSelector.class.getName(),
            (BookReviewSelector) bookReviewSelectorMock.getMock()
        );

        // execute
        Test.startTest();
        BookSearchService service = new BookSearchService();
        service.getBooksFromSearchDTO(bookDTO, 1, 1 );
        List<Book__c> books = service.getResponse();
        Test.stopTest();

        // assert
        Assert.areEqual(0, books.size(), 'The response book list should be empty as no matches were found');
    }

    @IsTest
    static void getBooksFromSearchDTO_IfSearchParametersPartiallySetAndMatch_WillSetResponseToMatchingBookList() {
        // create testFactory
        TestFactory testFactory = new TestFactory();

        //create and insert Author__c object
        Author__c author = testFactory.createAuthor(false, true);

        // create and insert Publisher__c object
        Publisher__c publisher = testFactory.createPublisher(false, true);

        //create and insert Book__c object
        Book__c book = testFactory.createBook(publisher.Id, author.Id, false, true);

        //create and insert Bookstore__c objects
        Bookstore__c bookstore = testFactory.createBookstore(false, true);

        //create Bookstore_Publisher__c junction object
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false, true);

        //create Bookstore_Book__c junction object
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false, true);

        //create BookSearchDTO, reset name and reviewScore to null
        BookSearchDTO bookDTO = new TestFactory().createBookSearchDTO(author.Id, publisher.Id, bookstore.Id);
        bookDTO.name=null;
        bookDTO.reviewScore=null;

        // create mock
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getListFromQueryConditions', new List<Book__c>{book});
        // set mock
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMock.getMock()
        );

        //create mock
        Mocker bookReviewSelectorMock = new Mocker(BookReviewSelector.class)
            .setBehavior('getAverageRatingListByBookIdSet', new List<AggregateResult>{});
        // set mock
        ObjectFactory.mocks.put(
            BookReviewSelector.class.getName(),
            (BookReviewSelector) bookReviewSelectorMock.getMock()
        );

        // execute
        Test.startTest();
        BookSearchService service = new BookSearchService();
        service.getBooksFromSearchDTO(bookDTO, null, null );
        List<Book__c> books = service.getResponse();
        Test.stopTest();

        // assert
        Assert.areEqual(1, books.size(), 'The response book list should contain a single match');
        Assert.areEqual(book, books[0], 'Incorrect record added to the list');
    }
}