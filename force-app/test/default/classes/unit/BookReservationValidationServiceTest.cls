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

        // execute
        BookReservationValidationService bookReservationValidationService = new BookReservationValidationService();
        bookReservationValidationService.validateSelectedBook(null, new List<Book_Reservation__c>{bookReservation});

        // assert
        bookstoreBookSelectorMock.assertMethodExecutionCount('getListByBookstoreAndBookIds', 1);
    }

    @isTest
    public static void validateSelectedBook_WillNotAddError_IfThereIsBookInBookstore() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(false);
        insert bookstore;
        Publisher__c publisher = testFactory.createPublisher(false);
        insert publisher;
        Author__c author = testFactory.createAuthor(false);
        insert author;
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false);
        insert bookstorePublisher;
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, false);
        insert authorPublisher;
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, false);
        insert book;
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false);
        insert bookstoreBook;
        Book_Reservation__c bookReservation = testFactory.createBookReservation(bookstore.Id, book.Id, false);
        insert bookReservation;

        // execute
        BookReservationValidationService bookReservationValidationService = new BookReservationValidationService();
        bookReservationValidationService.validateSelectedBook(null, new List<Book_Reservation__c>{bookReservation});

        // assert
        Assert.isTrue(bookReservation.getErrors().size() == 0);
    }
    
    @isTest
    public static void validateSelectedBook_WillAddError_IfThereIsNoBookInSelectedBookstoreWhenRecordIsBeingCreated() {
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

       // execute
       BookReservationValidationService bookReservationValidationService = new BookReservationValidationService();
       bookReservationValidationService.validateSelectedBook(null, new List<Book_Reservation__c>{bookReservation});

       // assert
       Assert.isTrue(bookReservation.getErrors().size() == 1);
       Assert.areEqual('There is no selected Book in selected Bookstore!', bookReservation.getErrors()[0].getMessage());
    }
    
    @isTest
    public static void validateSelectedBook_WillAddError_IfThereIsNoBookInBookstoreWhenRecordIsBeingUpdated() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(false);
        insert bookstore;
        Publisher__c publisher = testFactory.createPublisher(false);
        insert publisher;
        Author__c author = testFactory.createAuthor(false);
        insert author;
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false);
        insert bookstorePublisher;
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, false);
        insert authorPublisher;
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, false);
        insert book;
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false);
        insert bookstoreBook;
        Book_Reservation__c bookReservation = testFactory.createBookReservation(bookstore.Id, book.Id, false);
        insert bookReservation;
        delete bookstoreBook;
        bookReservation.Quantity__c = 2;

        Test.startTest();
        Database.SaveResult updateResult = Database.update(bookReservation, false);
        Test.stopTest();

        Assert.isTrue(updateResult.getErrors().size() == 1);
        Assert.areEqual('There is no selected Book in selected Bookstore!', updateResult.getErrors()[0].getMessage());
    }


    @isTest
    public static void validateSelectedBook_WillAddError_IfThereAreNoEnoughBooksWhenRecordIsBeingInserted() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(false);
        insert bookstore;
        Publisher__c publisher = testFactory.createPublisher(false);
        insert publisher;
        Author__c author = testFactory.createAuthor(false);
        insert author;
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false);
        insert bookstorePublisher;
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, false);
        insert authorPublisher;
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, false);
        insert book;
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false);
        insert bookstoreBook;
        Book_Reservation__c bookReservation = new Book_Reservation__c(Bookstore__c = bookstore.Id, Book__c = book.Id, Quantity__c = 11, Price__c = 10.59);

        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookReservation, false);
        Test.stopTest();

        Assert.isTrue(insertResult.getErrors().size() == 1);
        Assert.areEqual('There are no enough books! You can choose up to 10.', insertResult.getErrors()[0].getMessage());
    }

    @isTest
    public static void validateSelectedBook_WillAddError_IfThereAreNoEnoughBooksWhenRecordIsBeingUpdated() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(false);
        insert bookstore;
        Publisher__c publisher = testFactory.createPublisher(false);
        insert publisher;
        Author__c author = testFactory.createAuthor(false);
        insert author;
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false);
        insert bookstorePublisher;
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, false);
        insert authorPublisher;
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, false);
        insert book;
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false);
        insert bookstoreBook;
        Book_Reservation__c bookReservation = testFactory.createBookReservation(bookstore.Id, book.Id, false);
        insert bookReservation;
        bookReservation.Quantity__c = 11;

        Test.startTest();
        Database.SaveResult updateResult = Database.update(bookReservation, false);
        Test.stopTest();

        Assert.isTrue(updateResult.getErrors().size() == 1);
        Assert.areEqual('There are no enough books! You can choose up to 10.', updateResult.getErrors()[0].getMessage());
    }

    @isTest
    public static void validateSelectedBook_WillAddOneError_IfOneBookOutOfTwoIsNotAddedToBookstoreWhenRecordIsBeingCreated() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(false);
        insert bookstore;
        Publisher__c publisher = testFactory.createPublisher(false);
        insert publisher;
        Author__c author = testFactory.createAuthor(false);
        insert author;
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false);
        insert bookstorePublisher;
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, false);
        insert authorPublisher;
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, false);
        insert book;
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false);
        insert bookstoreBook;
        Book_Reservation__c bookReservation1 = new Book_Reservation__c(Bookstore__c = bookstore.Id, Book__c = book.Id, Quantity__c = 1, Price__c = 10.59);
        Book__c book1 = testFactory.createPaperBook(publisher.Id, author.Id, false);
        book1.ISBN__c = '124462465';
        insert book1;
        Book_Reservation__c bookReservation2 = new Book_Reservation__c(Bookstore__c = bookstore.Id, Book__c = book1.Id, Quantity__c = 1, Price__c = 10.59);

        List<Book_Reservation__c> reservations = new List<Book_Reservation__c>{bookReservation1, bookReservation2};

        Test.startTest();
        List<Database.SaveResult> insertResults = Database.insert(reservations, false);
        Test.stopTest();

        Assert.isTrue(insertResults[0].isSuccess());
        Assert.isFalse(insertResults[1].isSuccess());
        Assert.isTrue(insertResults[1].getErrors().size() == 1);
        Assert.areEqual('There is no selected Book in selected Bookstore!', insertResults[1].getErrors()[0].getMessage());
    }

    @isTest
    public static void validateSelectedBook_WillAddOneError_IfOneBookOutOfTwoIsNotAddedToBookstoreWhenRecordIsBeingUpdated() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(false);
        insert bookstore;
        Publisher__c publisher = testFactory.createPublisher(false);
        insert publisher;
        Author__c author = testFactory.createAuthor(false);
        insert author;
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false);
        insert bookstorePublisher;
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, false);
        insert authorPublisher;
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, false);
        insert book;
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false);
        insert bookstoreBook;
        Book_Reservation__c bookReservation1 = testFactory.createBookReservation(bookstore.Id, book.Id, false);
        insert bookReservation1;
        Book__c book1 = testFactory.createPaperBook(publisher.Id, author.Id, false);
        book1.ISBN__c = '21453425';
        insert book1;
        Bookstore_Book__c bookstoreBook1 = testFactory.createBookstoreBook(book1.Id, bookstore.Id, false);
        insert bookstoreBook1;
        Book_Reservation__c bookReservation2 = testFactory.createBookReservation(bookstore.Id, book1.Id, false);
        insert bookReservation2;
        delete bookstoreBook1;
        bookReservation1.Quantity__c = 3;
        bookReservation2.Quantity__c = 4;

        List<Book_Reservation__c> reservations = new List<Book_Reservation__c>{bookReservation1, bookReservation2};

        Test.startTest();
        List<Database.SaveResult> updateResults = Database.update(reservations, false);
        Test.stopTest();

        Assert.isTrue(updateResults[0].isSuccess());
        Assert.isFalse(updateResults[1].isSuccess());
        Assert.isTrue(updateResults[1].getErrors().size() == 1);
        Assert.areEqual('There is no selected Book in selected Bookstore!', updateResults[1].getErrors()[0].getMessage());
    }
}