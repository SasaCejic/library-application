/*
* This class retrieves all the Book records not in the bookstore provided by bookstoreID
*/
public with sharing class GetBooksNotInBookstoreService implements CustomObject{
    private List<Book__c> response;
    //Getter
    public List<Book__c> getResponse() {
        return this.response;
    }
    //Setter
    public void setResponse(List<Book__c> bookList) {
        this.response = bookList;
    }
    /*
    * @param bookstoreId - Id of the bookstore 
    */
    public void getBooks(Id bookstoreId) {
        //Set of book ids that are already in bookstore
        Set<Id> booksInBookstoreIds = new Set<Id>();
        BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory()
        .createObject(BookstoreBookSelector.class);
        //Get all bookstoreBooks assigned to Bookstore by bookstore Id
        List<Bookstore_Book__c> bookstoreBooksInBookstore = bookstoreBookSelector.getListByBookstoreId(bookstoreId);
        //Loop through all the bookstoreBooks in bookstore and add Book ids to the set
        for(Bookstore_Book__c bookstoreBook:bookstoreBooksInBookstore) {
            booksInBookstoreIds.add(bookstoreBook.Book__c);
        }
        //Get all the books that are not in the bookstore
        BookSelector bookSelector = (BookSelector) new ObjectFactory()
        .createObject(BookSelector.class);
        List<Book__c> allBooks = bookSelector.getBooksNotInSet(booksInBookstoreIds);
        this.setResponse(allBooks);
    }
}