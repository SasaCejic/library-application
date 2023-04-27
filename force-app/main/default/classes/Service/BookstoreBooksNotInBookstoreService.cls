/*
* This class retrieves all the BookstoreBook records not in the bookstore provided by bookstoreID
*/
public with sharing class BookstoreBooksNotInBookstoreService implements CustomObject{
    /*
    * @param bookstoreId - Id of the bookstore 
    */
    public void getBookstoreBooksNotInBookstore(Id bookstoreId) {
        Set<Id> booksInBookstoreIds = new Set<Id>();
        BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory()
        .createObject(BookstoreBookSelector.class);
        List<Bookstore_Book__c> bookstoreBooksInBookstore = bookstoreBookSelector.getListByBookstoreId(bookstoreId);
        //Loop through all the bookstoreBooks in bookstore and add Book ids to the set
        for(Bookstore_Book__c bookstoreBook:bookstoreBooksInBookstore) {
            booksInBookstoreIds.add(bookstoreBook.Book__c);
        }
        //Get all the books that are not in the bookstore
        BookSelector bookSelector = (BookSelector) new ObjectFactory()
        .createObject(BookSelector.class);
        List<Book__c> allBooks = bookSelector.getBooksNotInSet(booksInBookstoreIds);
    }
}