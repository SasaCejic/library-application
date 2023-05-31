/**
 * this class perfomrs unit tests for BookReservationCancelationService class
 * 
 * @see BookReservationCancelationService.cls
 */
@isTest
public with sharing class BookReservationCancelationServiceTest {
    @isTest
    public static void cancelBookReservation_WillUseCorrectSelectors() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(true);
        Publisher__c publisher = testFactory.createPublisher(true);
        Author__c author = testFactory.createAuthor(true);
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, true);
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, true);
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, true);
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, true);
        Book_Reservation__c bookReservation = testFactory.createBookReservation(bookstore.Id, book.Id, true);

        // create mocks
        Mocker bookstoreBookSelectorMock = new Mocker(BookstoreBookSelector.class)
        .setBehavior('getListByBookstoreAndBookIds', new List<Bookstore_Book__c>());
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector)bookstoreBookSelectorMock.getMock()
        );

        Mocker bookReservationSelectorMock = new Mocker(BookReservationSelector.class)
        .setBehavior('getListByIds', new List<Book_Reservation__c>());
        ObjectFactory.mocks.put(
            BookReservationSelector.class.getName(),
            (BookReservationSelector)bookReservationSelectorMock.getMock()
        );

        // execute
        BookReservationCancelationService bookReservationCancelationService = new BookReservationCancelationService();
        bookReservationCancelationService.cancelBookReservation(new List<Book_Reservation__c>{bookReservation});

        // assert
        bookstoreBookSelectorMock.assertMethodExecutionCount('getListByBookstoreAndBookIds', 1);
        bookReservationSelectorMock.assertMethodExecutionCount('getListByIds', 1);
    }

    @isTest
    public static void cancelBookReservation_WillNotAddError_IfBookReservationIsCanceled() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(true);
        Publisher__c publisher = testFactory.createPublisher(true);
        Author__c author = testFactory.createAuthor(true);
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, true);
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, true);
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, true);
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, true);
        Book_Reservation__c bookReservation = testFactory.createBookReservation(bookstore.Id, book.Id, true);

        // create mocks
        Mocker bookstoreBookSelectorMock = new Mocker(BookstoreBookSelector.class)
        .setBehavior('getListByBookstoreAndBookIds', new List<Bookstore_Book__c>{bookstoreBook});
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector)bookstoreBookSelectorMock.getMock()
        );

        Mocker bookReservationSelectorMock = new Mocker(BookReservationSelector.class)
        .setBehavior('getListByIds', new List<Book_Reservation__c>{bookReservation});
        ObjectFactory.mocks.put(
            BookReservationSelector.class.getName(),
            (BookReservationSelector)bookReservationSelectorMock.getMock()
        );

        // execute
        BookReservationCancelationService bookReservationCancelationService = new BookReservationCancelationService();
        bookReservationCancelationService.cancelBookReservation(new List<Book_Reservation__c>{bookReservation});

        // assert
        Assert.isTrue(bookReservation.getErrors().size() == 0);
    }
    
    @isTest
    public static void cancelBookReservation_WillNotCancelTheReservation_IfReservationIsNotActive() {
       // create data
       TestFactory testFactory = new TestFactory();
       Bookstore__c bookstore = testFactory.createBookstore(true);
       Publisher__c publisher = testFactory.createPublisher(true);
       Author__c author = testFactory.createAuthor(true);
       Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, true);
       Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, true);
       Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, true);
       Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, true);
       Book_Reservation__c bookReservation = testFactory.createBookReservation(bookstore.Id, book.Id, true);
       bookReservation.Status__c = 'Bought';
       Database.update(bookReservation, false);

       // create mocks
       Mocker bookstoreBookSelectorMock = new Mocker(BookstoreBookSelector.class)
       .setBehavior('getListByBookstoreAndBookIds', new List<Bookstore_Book__c>());
       ObjectFactory.mocks.put(
           BookstoreBookSelector.class.getName(),
           (BookstoreBookSelector)bookstoreBookSelectorMock.getMock()
       );

       Mocker bookReservationSelectorMock = new Mocker(BookReservationSelector.class)
       .setBehavior('getListByIds', new List<Book_Reservation__c>());
       ObjectFactory.mocks.put(
           BookReservationSelector.class.getName(),
           (BookReservationSelector)bookReservationSelectorMock.getMock()
       );

       // execute
       BookReservationCancelationService bookReservationCancelationService = new BookReservationCancelationService();
       bookReservationCancelationService.cancelBookReservation(new List<Book_Reservation__c>{bookReservation});


       // assert
       Assert.isTrue(bookReservation.Status__c != 'Canceled');
    }
}