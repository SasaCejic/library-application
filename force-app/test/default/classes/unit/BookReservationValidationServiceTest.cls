/**
 * this class perfomrs unit tests for BookReservationValidationService class
 * 
 * @see BookReservationValidationService.cls
 */
@isTest
public with sharing class BookReservationValidationServiceTest {
    @isTest
    public static void validateSelectedBook_WillUseCorrectSelector() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(false, true);
        Publisher__c publisher = testFactory.createPublisher(false, true);
        Author__c author = testFactory.createAuthor(false, true);
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false, true);
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, false, true);
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, false, true);
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false, true);
        Book_Reservation__c bookReservation = testFactory.createBookReservation(bookstore.Id, book.Id, false, true);

        // create mocks
        Mocker bookstoreBookSelectorMock = new Mocker(BookstoreBookSelector.class)
        .setBehavior('getListByUniqueConcatanatedIds', new List<Bookstore_Book__c>());
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector)bookstoreBookSelectorMock.getMock()
        );

        // execute
        BookReservationValidationService bookReservationValidationService = new BookReservationValidationService();
        bookReservationValidationService.validateSelectedBook(new List<Book_Reservation__c>{bookReservation});

        // assert
        bookstoreBookSelectorMock.assertMethodExecutionCount('getListByUniqueConcatanatedIds', 1);
    }

    @isTest
    public static void validateSelectedBook_WillNotAddError_IfThereIsBookInBookstore() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(true, false);
        Publisher__c publisher = testFactory.createPublisher(true, false);
        Author__c author = testFactory.createAuthor(true, false);
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, true, false);
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, true, false);
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, true, false);
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, true, false);
        Book_Reservation__c bookReservation = testFactory.createBookReservation(bookstore.Id, book.Id, true, false);

        // execute
        BookReservationValidationService bookReservationValidationService = new BookReservationValidationService();
        bookReservationValidationService.validateSelectedBook(new List<Book_Reservation__c>{bookReservation});

        // assert
        Assert.isTrue(bookReservation.getErrors().size() == 0);
    }
    
    @isTest
    public static void validateSelectedBook_WillAddError_IfThereIsNoBookInSelectedBookstore() {
       // create data
       TestFactory testFactory = new TestFactory();
       Bookstore__c bookstore = testFactory.createBookstore(false, true);
       Publisher__c publisher = testFactory.createPublisher(false, true);
       Author__c author = testFactory.createAuthor(false, true);
       Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false, true);
       Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, false, true);
       Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, false, true);
       Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false, true);
       Book_Reservation__c bookReservation = testFactory.createBookReservation(bookstore.Id, book.Id, false, true);

       // create mocks
       Mocker bookstoreBookSelectorMock = new Mocker(BookstoreBookSelector.class)
       .setBehavior('getListByUniqueConcatanatedIds', new List<Bookstore_Book__c>());
       ObjectFactory.mocks.put(
           BookstoreBookSelector.class.getName(),
           (BookstoreBookSelector)bookstoreBookSelectorMock.getMock()
       );

       // execute
       BookReservationValidationService bookReservationValidationService = new BookReservationValidationService();
       bookReservationValidationService.validateSelectedBook(new List<Book_Reservation__c>{bookReservation});

       // assert
       Assert.isTrue(bookReservation.getErrors().size() == 1);
       Assert.areEqual('There is no selected Book in selected Bookstore!', bookReservation.getErrors()[0].getMessage());
    }
}