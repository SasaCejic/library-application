public with sharing class BookReservationCancelationService {
    public void cancelBookReservation (List<Book_Reservation__c> bookReservations) {
        // bookReservation.Status__c = bookReservation.Status__c == 'Active' ? 'Canceled' : bookReservation.Status__c;
        //TODO Find Bookstore Book 
        // bookstoreBook.Number_Of_Active_Reservations__c -= bookReservation.Quantity__c;

        // Database.update(bookReservation);
        // Database.update(bookstoreBook);
    }
}