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
        if (oldBookReservations != null) {
            //If the record is being updated
            List<Book_Reservation__c> reservationsToProcess = new List<Book_Reservation__c>();

            for (Book_Reservation__c oldReservation : oldBookReservations) {
                for (Book_Reservation__c newReservation : newBookReservations) {
                    if (oldReservation.Id == newReservation.Id && (oldReservation.Quantity__c != newReservation.Quantity__c || oldReservation.Bookstore__c != newReservation.Bookstore__c || oldReservation.Book__c != newReservation.Book__c)) {
                        reservationsToProcess.add(newReservation);
                    }
                }
            }

            if (!reservationsToProcess.isEmpty()) {
                BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory().createObject(BookstoreBookSelector.class);
                Set<String> concatanatedIds = new Set<String>();

                for (Book_Reservation__c bookReservation : reservationsToProcess) {
                    String concatanatedId = (String) bookReservation.Bookstore__c + (String) bookReservation.Book__c;
                    concatanatedIds.add(concatanatedId);
                }

                List<Bookstore_Book__c> bookstoreBooks = bookstoreBookSelector.getListByUniqueConcatanatedIds(concatanatedIds);

                if(!bookstoreBooks.isEmpty()) {
                    List<Bookstore_Book__c> bookstoreBooksToUpdate = new List<Bookstore_Book__c>();
    
                    for (Book_Reservation__c bookReservation : reservationsToProcess) {
                        Boolean bookFound = false;
                        for (Bookstore_Book__c bookstoreBook : bookstoreBooks) {
                            if (bookReservation.Bookstore__c == bookstoreBook.Bookstore__c && bookReservation.Book__c == bookstoreBook.Book__c) {
                                bookFound = true;

                                for (Book_Reservation__c oldReservation : oldBookReservations) {
                                    if (oldReservation.Id == bookReservation.Id && oldReservation.Quantity__c != bookReservation.Quantity__c) {
                                        bookstoreBook.Number_Of_Active_Reservations__c -= oldReservation.Quantity__c;
                                    }
                                }
                                if (bookReservation.Quantity__c > bookstoreBook.Quantity__c - bookstoreBook.Number_Of_Active_Reservations__c) {
                                    String errorMessage = (bookstoreBook.Quantity__c - bookstoreBook.Number_Of_Active_Reservations__c > 0) ? 'There are no enough books! You can choose up to ' + (bookstoreBook.Quantity__c - bookstoreBook.Number_Of_Active_Reservations__c) + '.' : 'There is no selected Book in selected Bookstore!';
                                    bookReservation.addError(errorMessage);
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
                        if (!bookFound) {
                            bookReservation.addError('There is no selected Book in selected Bookstore!');
                        }
                    }
                    if (!bookstoreBooksToUpdate.isEmpty()) {
                        update bookstoreBooksToUpdate;
                    }
                } else {
                    for (Book_Reservation__c bookReservation : reservationsToProcess) {
                        bookReservation.addError('There is no selected Book in selected Bookstore!');
                    }
                }
            }
        } else {
            //If the record is being inserted
            BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory().createObject(BookstoreBookSelector.class);
            Set<String> concatanatedIds = new Set<String>();
    
            for (Book_Reservation__c bookReservation : newBookReservations) {
                String concatanatedId = (String) bookReservation.Bookstore__c + (String) bookReservation.Book__c;
                concatanatedIds.add(concatanatedId);
            }
    
            List<Bookstore_Book__c> bookstoreBooks = bookstoreBookSelector.getListByUniqueConcatanatedIds(concatanatedIds);
    
            if(!bookstoreBooks.isEmpty()) {
                List<Bookstore_Book__c> bookstoreBooksToUpdate = new List<Bookstore_Book__c>();
        
                for (Book_Reservation__c bookReservation : newBookReservations) {
                    Boolean bookFound = false;
                    for (Bookstore_Book__c bookstoreBook : bookstoreBooks) {
                        if (bookReservation.Bookstore__c == bookstoreBook.Bookstore__c && bookReservation.Book__c == bookstoreBook.Book__c) {
                            bookFound = true;
                            if (bookReservation.Quantity__c > bookstoreBook.Quantity__c - bookstoreBook.Number_Of_Active_Reservations__c) {
                                String errorMessage = (bookstoreBook.Quantity__c - bookstoreBook.Number_Of_Active_Reservations__c > 0) ? 'There are no enough books! You can choose up to ' + (bookstoreBook.Quantity__c - bookstoreBook.Number_Of_Active_Reservations__c) + '.' : 'There is no selected Book in selected Bookstore!';
                                bookReservation.addError(errorMessage);
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
                    if (!bookFound) {
                        bookReservation.addError('There is no selected Book in selected Bookstore!');
                    }
                }
                if (!bookstoreBooksToUpdate.isEmpty()) {
                    update bookstoreBooksToUpdate;
                }
            } else {
                for (Book_Reservation__c bookReservation : newBookReservations) {
                    bookReservation.addError('There is no selected Book in selected Bookstore!');
                }
            }
        }
    }
}