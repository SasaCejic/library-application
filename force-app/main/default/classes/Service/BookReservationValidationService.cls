/**
 * Class that contains a method to validate if selected Bookstore has the appropriate
 * amound of selected books
 * 
 * @see BookReservationTriggerHandler.cls
 */
public with sharing class BookReservationValidationService implements CustomObject {

    /**
     * Method which checks if Bookstore contains the appropriate amount of selected Books
     * when new reservations are being created
     * 
     * @param newBookReservation list of new BookReservation records
     */
    public void validateSelectedBook (List<Book_Reservation__c> newBookReservations) {
        BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory().createObject(BookstoreBookSelector.class);
        Set<String> concatanatedIds = new Set<String>();

        for (Book_Reservation__c bookReservation : newBookReservations) {
            String concatanatedId = (String) bookReservation.Bookstore__c + (String) bookReservation.Book__c;
            concatanatedIds.add(concatanatedId);
        }

        List<Bookstore_Book__c> bookstoreBooks = bookstoreBookSelector.getListByUniqueConcatanatedIds(concatanatedIds);

        if(!bookstoreBooks.isEmpty()) {
            List<Bookstore_Book__c> bookstoreBooksToUpdate = new List<Bookstore_Book__c>();
            List<Bookstore_Book__c> bookstoreBooksToDelete = new List<Bookstore_Book__c>();
    
            for (Book_Reservation__c bookReservation : newBookReservations) {
                for (Bookstore_Book__c bookstoreBook : bookstoreBooks) {
                    if (bookReservation.Bookstore__c == bookstoreBook.Bookstore__c && bookReservation.Book__c == bookstoreBook.Book__c) {
                        if (bookReservation.Quantity__c > bookstoreBook.Quantity__c) {
                            bookReservation.addError('There are no enough books! You can choose up to ' + bookstoreBook.Quantity__c + '.');
                        } else {
                            bookstoreBook.Quantity__c -= bookReservation.Quantity__c;
                            if (bookstoreBook.Quantity__c == 0) {
                                bookstoreBooksToDelete.add(bookstoreBook);
                            } else {
                                bookstoreBooksToUpdate.add(bookstoreBook);
                            }
                        }
                    }
                }
            }
            if (!bookstoreBooksToDelete.isEmpty()) {
                delete bookstoreBooksToDelete;
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

    /**
     * Method which checks if Bookstore contains the appropriate amount of selected Books
     * when old reservations are being updated
     * 
     * @param oldBookReservations list of BookReservation records with old values
     * @param newBookReservation list of BookReservation records with new values
     */
    public void validateSelectedBook (List<Book_Reservation__c> oldBookReservations, List<Book_Reservation__c> newBookReservations) {
        List<Book_Reservation__c> reservationsWithNewBookstoreBooks = new List<Book_Reservation__c>();
        List<Book_Reservation__c> reservationsWithNewQuantities = new List<Book_Reservation__c>();
        List<Book_Reservation__c> reservationsWithNewQuantitiesAndBookstoreBooks = new List<Book_Reservation__c>();

        for (Book_Reservation__c oldReservation : oldBookReservations) {
            for (Book_Reservation__c newReservation : newBookReservations) {
                if (oldReservation.Id == newReservation.Id) {
                    if ((oldReservation.Bookstore__c != newReservation.Bookstore__c || oldReservation.Book__c != newReservation.Book__c) && oldReservation.Quantity__c == newReservation.Quantity__c) {
                        reservationsWithNewBookstoreBooks.add(newReservation);
                    } else if (oldReservation.Bookstore__c == newReservation.Bookstore__c && oldReservation.Book__c == newReservation.Book__c && oldReservation.Quantity__c != newReservation.Quantity__c) {
                        reservationsWithNewQuantities.add(newReservation);
                    } else if ((oldReservation.Bookstore__c != newReservation.Bookstore__c || oldReservation.Book__c != newReservation.Book__c) && oldReservation.Quantity__c != newReservation.Quantity__c) {
                        reservationsWithNewQuantitiesAndBookstoreBooks.add(newReservation);
                    }
                }
            }
        }

        BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory().createObject(BookstoreBookSelector.class);
        Set<String> concatanatedIds = new Set<String>();

        for (Book_Reservation__c bookReservation : newBookReservations) {
            String concatanatedId = (String) bookReservation.Bookstore__c + (String) bookReservation.Book__c;
            concatanatedIds.add(concatanatedId);
        }

        List<Bookstore_Book__c> bookstoreBooks = bookstoreBookSelector.getListByUniqueConcatanatedIds(concatanatedIds);

        if(!bookstoreBooks.isEmpty()) {
            List<Bookstore_Book__c> bookstoreBooksToUpdate = new List<Bookstore_Book__c>();
            List<Bookstore_Book__c> bookstoreBooksToDelete = new List<Bookstore_Book__c>();
    
            for (Book_Reservation__c bookReservation : newBookReservations) {
                for (Bookstore_Book__c bookstoreBook : bookstoreBooks) {
                    if (bookReservation.Bookstore__c == bookstoreBook.Bookstore__c && bookReservation.Book__c == bookstoreBook.Book__c) {
                        if (bookReservation.Quantity__c > bookstoreBook.Quantity__c) {
                            bookReservation.addError('There are no enough books! You can choose up to ' + bookstoreBook.Quantity__c + '.');
                        } else {
                            bookstoreBook.Quantity__c -= bookReservation.Quantity__c;
                            if (bookstoreBook.Quantity__c == 0) {
                                bookstoreBooksToDelete.add(bookstoreBook);
                            } else {
                                bookstoreBooksToUpdate.add(bookstoreBook);
                            }
                        }
                    }
                }
            }
            if (!bookstoreBooksToDelete.isEmpty()) {
                delete bookstoreBooksToDelete;
            }
            if (!bookstoreBooksToUpdate.isEmpty()) {
                update bookstoreBooksToUpdate;
            }
        } else {
            List<Bookstore_Book__c> bookstoreBooksToInsert = new List<Bookstore_Book__c>();

            for (Book_Reservation__c bookReservation : newBookReservations) {
                if (!reservationsWithNewQuantities.contains(bookReservation)) {
                    bookReservation.addError('There is no selected Book in selected Bookstore!');
                } else {
                    Integer oldQuantity = 0;

                    for (Book_Reservation__c oldReservation : oldBookReservations) {
                        if (oldReservation.Id == bookReservation.Id) {
                            oldQuantity = (Integer) oldReservation.Quantity__c;
                        }
                    }

                    if (bookReservation.Quantity__c > oldQuantity) {
                        bookReservation.addError('There are no enough books! You can choose up to ' + oldQuantity);
                    } else if (bookReservation.Quantity__c < oldQuantity) {
                        Bookstore_Book__c bsb = new Bookstore_Book__c();

                        bsb.Bookstore__c = bookReservation.Bookstore__c;
                        bsb.Book__c = bookReservation.Book__c;
                        bsb.Quantity__c = oldQuantity - bookReservation.Quantity__c;

                        bookstoreBooksToInsert.add(bsb);
                    }
                }
            }

            if (!bookstoreBooksToInsert.isEmpty()) {
                insert bookstoreBooksToInsert;
            }
        }
    }
}