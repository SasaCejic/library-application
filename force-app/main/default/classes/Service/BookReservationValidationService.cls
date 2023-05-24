/**
 * Class that contains a method to validate if selected Bookstore has the appropriate
 * amound of selected books
 * 
 * @see BookReservationTriggerHandler.cls
 */
public with sharing class BookReservationValidationService implements CustomObject {
    /**
     * Method which checks if Bookstore contains the appropriate amount of selected Books
     * when reservations are being created or updated
     * 
     * @param oldBookReservations list of BookReservation records with old values (this is null if the record is being created)
     * @param newBookReservation list of BookReservation records with new values
     */
    public void validateSelectedBook (List<Book_Reservation__c> oldBookReservations, List<Book_Reservation__c> newBookReservations) {
        Set<Id> bookstoreIds = new Set<Id>();
        Set<Id> bookIds = new Set<Id>();

        for (Book_Reservation__c bookReservation : newBookReservations) {
            bookstoreIds.add(bookReservation.Bookstore__c);
            bookIds.add(bookReservation.Book__c);
        }

        BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory().createObject(BookstoreBookSelector.class);
        List<Bookstore_Book__c> bookstoreBooks = bookstoreBookSelector.getListByBookstoreAndBookIds(bookstoreIds, bookIds);

        List<Bookstore_Book__c> bookstoreBooksToUpdate = new List<Bookstore_Book__c>();

        for (Book_Reservation__c bookReservation : newBookReservations) {
            Boolean noBookstoreBooks = true;
            for (Bookstore_Book__c bookstoreBook : bookstoreBooks) {
                if (bookReservation.Bookstore__c == bookstoreBook.Bookstore__c && bookReservation.Book__c == bookstoreBook.Book__c) {
                    noBookstoreBooks = false;
                    if (oldBookReservations != null) {
                        /*If the reservation is being updated, we need to find the old reservation quantity to take it into account
                        because BookstoreBook Quantity is not reduced yet when the reservation is active */
                        for (Book_Reservation__c oldReservation : oldBookReservations) {
                            if (bookReservation.Id == oldReservation.Id) {
                                Integer availableBooks = (Integer) bookstoreBook.Quantity__c - (Integer) bookstoreBook.Number_Of_Active_Reservations__c + (Integer) oldReservation.Quantity__c;
                        
                                if (bookReservation.Quantity__c > availableBooks) {
                                    bookReservation.addError('There are no enough books! You can choose up to ' + availableBooks + '.');
                                } else {
                                    bookstoreBook.Number_Of_Active_Reservations__c = bookstoreBook.Number_Of_Active_Reservations__c - oldReservation.Quantity__c + bookReservation.Quantity__c;
                                    bookstoreBooksToUpdate.add(bookstoreBook);
                                    //Send confirmation email
                                    SendReservationEmailConfirmationService confirmationEmail = (SendReservationEmailConfirmationService) new ObjectFactory().createObject(SendReservationEmailConfirmationService.class);
                                    Decimal totalPrice = bookstoreBook.Book__r.Price__c * (Integer) bookReservation.Quantity__c;
                                    bookReservation.Price__c = totalPrice;
                                    confirmationEmail.sendMail(UserInfo.getUserEmail(), bookstoreBook.Book__r.Name, (Integer) bookReservation.Quantity__c, totalPrice);
                                }
                            }
                        }

                    } else {
                        Integer availableBooks = (Integer) bookstoreBook.Quantity__c - (Integer) bookstoreBook.Number_Of_Active_Reservations__c;
                        
                        if (bookReservation.Quantity__c > availableBooks) {
                            bookReservation.addError('There are no enough books! You can choose up to ' + availableBooks + '.');
                        } else {
                            bookstoreBook.Number_Of_Active_Reservations__c += bookReservation.Quantity__c;
                            bookstoreBooksToUpdate.add(bookstoreBook);
                            //Send confirmation email
                            SendReservationEmailConfirmationService confirmationEmail = (SendReservationEmailConfirmationService) new ObjectFactory().createObject(SendReservationEmailConfirmationService.class);
                            Decimal totalPrice = bookstoreBook.Book__r.Price__c * (Integer) bookReservation.Quantity__c;
                            bookReservation.Price__c = totalPrice;
                            confirmationEmail.sendMail(UserInfo.getUserEmail(), bookstoreBook.Book__r.Name, (Integer) bookReservation.Quantity__c, totalPrice);
                        }
                    }
                }
            }
            if (noBookstoreBooks) {
                bookReservation.addError('There is no selected Book in selected Bookstore!');
            }
        }

        if (!bookstoreBooksToUpdate.isEmpty()) {
            Database.update(bookstoreBooksToUpdate, false);
        }
    }
}