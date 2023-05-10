/**
 * Class that contains a method to validate if selected Bookstore has the appropriate
 * amound of selected books
 * 
 * @see BookReservationTriggerHandler.cls
 */
public with sharing class BookReservationValidationService implements CustomObject {

    /**
     * Method which checks if Bookstore contains the appropriate amount of selected Books
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
            for (Book_Reservation__c bookReservation : newBookReservations) {
                for (Bookstore_Book__c bookstoreBook : bookstoreBooks) {
                    if (bookReservation.Bookstore__c == bookstoreBook.Bookstore__c && bookReservation.Book__c == bookstoreBook.Book__c) {
                        if (bookReservation.Quantity__c > bookstoreBook.Quantity__c) {
                            bookReservation.addError('There are no enough books! You can choose up to ' + bookstoreBook.Quantity__c + '.');
                        }
                    }
                }
            }
        } else {
            for (Book_Reservation__c bookReservation : newBookReservations) {
                bookReservation.addError('There is no selected Book in selected Bookstore!');
            }
        }
    }
}