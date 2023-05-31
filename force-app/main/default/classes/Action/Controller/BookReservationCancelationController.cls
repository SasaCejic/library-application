public with sharing class BookReservationCancelationController {
    @InvocableMethod
    public static void cancelBookReservation (List<Book_Reservation__c> bookReservations) {
        BookReservationCancelationService service = (BookReservationCancelationService) new ObjectFactory()
            .createObject(BookReservationCancelationService.class);
        service.cancelBookReservation(bookReservations);
    }
}