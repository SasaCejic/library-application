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
        List<List<Bookstore_Book__c>> bookstoreBooksByReservations = new List<List<Bookstore_Book__c>>(newBookReservations.size());

        for (Book_Reservation__c bookReservation : newBookReservations) {
            List<Bookstore_Book__c> foundBookstoreBooks = new List<Bookstore_Book__c>();    
            for (Bookstore_Book__c bookstoreBook : bookstoreBooks) {
                if (bookReservation.Bookstore__c == bookstoreBook.Bookstore__c && bookReservation.Book__c == bookstoreBook.Book__c) {
                    foundBookstoreBooks.add(bookstoreBook);
                }
            }
            bookstoreBooksByReservations[newBookReservations.indexOf(bookReservation)] = foundBookstoreBooks;
        }

        if (oldBookReservations != null) {
            Map<Id, Book_Reservation__c> newReservationsByIds = new Map<Id, Book_Reservation__c>();
            for (Book_Reservation__c bookReservation : newBookReservations) {
                newReservationsByIds.put(bookReservation.Id, bookReservation);
            }
            
            for (Book_Reservation__c oldReservation : oldBookReservations) {
                Book_Reservation__c bookReservation = newReservationsByIds.get(oldReservation.Id);

                for (Bookstore_Book__c bookstoreBook : bookstoreBooksByReservations[newBookReservations.indexOf(bookReservation)]) {
                    this.checkForQuantity(oldReservation, bookReservation, bookstoreBook, bookstoreBooksToUpdate);
                }
            }
        } else {
            for (Book_Reservation__c bookReservation : newBookReservations) {
                for (Bookstore_Book__c bookstoreBook : bookstoreBooksByReservations[newBookReservations.indexOf(bookReservation)]) {
                    this.checkForQuantity(null, bookReservation, bookstoreBook, bookstoreBooksToUpdate);
                }
            }
        }

        for (Book_Reservation__c reservation : newBookReservations) {
            if (bookstoreBooksByReservations[newBookReservations.indexOf(reservation)].isEmpty()) {
                reservation.addError('There is no selected Book in selected Bookstore!');
            }
        }

        if (!bookstoreBooksToUpdate.isEmpty()) {
            Database.update(bookstoreBooksToUpdate, false);
        }
    }

    private void checkForQuantity (Book_Reservation__c oldReservation, Book_Reservation__c newReservation, Bookstore_Book__c bookstoreBook, List<Bookstore_Book__c> bookstoreBooksToUpdate) {
        Integer availableBooks = (oldReservation != null) ? (Integer) bookstoreBook.Quantity__c - (Integer) bookstoreBook.Number_Of_Active_Reservations__c + (Integer) oldReservation.Quantity__c : (Integer) bookstoreBook.Quantity__c - (Integer) bookstoreBook.Number_Of_Active_Reservations__c;

        if (newReservation.Quantity__c > availableBooks) {
            newReservation.addError('There are no enough books! You can choose up to ' + availableBooks + '.');
        } else {
            bookstoreBook.Number_Of_Active_Reservations__c = (oldReservation != null) ? bookstoreBook.Number_Of_Active_Reservations__c - oldReservation.Quantity__c + newReservation.Quantity__c : bookstoreBook.Number_Of_Active_Reservations__c + newReservation.Quantity__c;
            bookstoreBooksToUpdate.add(bookstoreBook);
            //Send confirmation email
            SendReservationEmailConfirmationService confirmationEmail = (SendReservationEmailConfirmationService) new ObjectFactory().createObject(SendReservationEmailConfirmationService.class);
            Decimal totalPrice = bookstoreBook.Book__r.Price__c * (Integer) newReservation.Quantity__c;
            newReservation.Price__c = totalPrice;
            confirmationEmail.sendMail(UserInfo.getUserEmail(), bookstoreBook.Book__r.Name, (Integer) newReservation.Quantity__c, totalPrice);
        } 
    }
}