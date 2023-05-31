/**
 * This class is used as a service for Book_Reservation__c cancelation
 */
public with sharing class BookReservationCancelationService implements CustomObject{
    /**
     * Change Status of a Book Reservation and number of active reservations
     * in related Bookstore Book object
     * 
     * @param bookReservations List of Book_Reservation records which status is going to be changed
     */
    public void cancelBookReservation (List<Book_Reservation__c> bookReservations) {
        Set<Id> bookstoreIds = new Set<Id>();
        Set<Id> bookIds = new Set<Id>();

        for (Book_Reservation__c bookReservation : bookReservations) {
            bookstoreIds.add(bookReservation.Bookstore__c);
            bookIds.add(bookReservation.Book__c);
        }

        BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory().createObject(BookstoreBookSelector.class);
        List<Bookstore_Book__c> bookstoreBooks = bookstoreBookSelector.getListByBookstoreAndBookIds(bookstoreIds, bookIds);
        List<Bookstore_Book__c> bookstoreBooksToUpdate = new List<Bookstore_Book__c>();

        Set<Id> reservationIds = new Set<Id>();
        for (Book_Reservation__c reservation : bookReservations) {
            reservationIds.add(reservation.Id);
        }

        BookReservationSelector bookReservationSelector = (BookReservationSelector) new ObjectFactory().createObject(BookReservationSelector.class);
        List<Book_Reservation__c> reservationsWithUserInfo = bookReservationSelector.getListByIds(reservationIds);

        List<Book_Reservation__c> bookReservationsToUpdate = new List<Book_Reservation__c>();

        for (Book_Reservation__c bookReservation : bookReservations) {
            if (bookReservation.Status__c == 'Active') {
                for (Bookstore_Book__c bookstoreBook : bookstoreBooks) {
                    if (bookReservation.Book__c == bookstoreBook.Book__c && bookReservation.Bookstore__c == bookstoreBook.Bookstore__c) {
                        bookstoreBook.Number_Of_Active_Reservations__c -= bookReservation.Quantity__c;
                        if (!bookstoreBooksToUpdate.contains(bookstoreBook)) {
                            bookstoreBooksToUpdate.add(bookstoreBook);
                        }
                    }
                }
                bookReservation.Status__c = 'Canceled';
                bookReservationsToUpdate.add(bookReservation);

                for (Book_Reservation__c reservationWithUserInfo : reservationsWithUserInfo) {
                    if (bookReservation.Id == reservationWithUserInfo.Id) {
                        SendCancelationEmailConfirmationService cancelationMail = (SendCancelationEmailConfirmationService) new ObjectFactory().createObject(SendCancelationEmailConfirmationService.class);
                        cancelationMail.sendMail(reservationWithUserInfo.createdBy.Email, bookReservation.Name, reservationWithUserInfo.createdBy.Name);
                    }
                }
            }
        }

        if (!bookReservationsToUpdate.isEmpty()) {
            Database.update(bookReservationsToUpdate, false);
        }
        if (!bookstoreBooksToUpdate.isEmpty()) {
            Database.update(bookstoreBooksToUpdate, false);
        }
    }
}