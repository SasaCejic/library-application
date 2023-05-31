/**
 * This is a test class for BookReservationCancelationController
 * 
 * @see BookReservationCancelationController.cls
 */
@isTest
public with sharing class BookReservationCancelationControllerTest {
    @isTest
    public static void cancelBookReservation_WillUseCorrectService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Bookstore__c bookstore = testFactory.createBookstore(false);
        Publisher__c publisher = testFactory.createPublisher(false);
        Author__c author = testFactory.createAuthor(false);
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false);
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, false);
        Book__c book = testFactory.createPaperBook(publisher.Id, author.Id, false);
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false);
        Book_Reservation__c bookReservation = testFactory.createBookReservation(bookstore.Id, book.Id, false);

        // create mocks
        Mocker bookReservationCancelationServiceMock = new Mocker(BookReservationCancelationService.class)
        .setBehavior('cancelBookReservation', null);
        ObjectFactory.mocks.put(
            BookReservationCancelationService.class.getName(),
            (BookReservationCancelationService)bookReservationCancelationServiceMock.getMock()
        );

        Mocker bookReservationSelectorMock = new Mocker(BookReservationSelector.class)
        .setBehavior('getListByIds', new List<Book_Reservation__c>());
        ObjectFactory.mocks.put(
            BookReservationSelector.class.getName(),
            (BookReservationSelector)bookReservationSelectorMock.getMock()
        );

        // execute
        BookReservationCancelationController.cancelBookReservation(new List<Book_Reservation__c>{bookReservation});

        // assert
        bookReservationCancelationServiceMock.assertMethodExecutionCount('cancelBookReservation', 1);
    }
}