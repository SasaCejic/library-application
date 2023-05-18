/** 
 * Class responsible for returning all the Bookstore_Book__c records that will prevent deletion of Bookstore_Publisher__c record
 * @see BookstorePublisherController
 */
public with sharing class GetBokstoreBooksOnPublsherDeleteService implements CustomObject {
    private List<Bookstore_Book__c> response;

    //Getter
    public List<Bookstore_Book__c> getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(List<Bookstore_Book__c> bookstoreBookList) {
        this.response = bookstoreBookList;
    }

    /**
     * @param bookstorePublisherForDeleteId - Bookstore_Publisher__c Id 
     * @param recordLimit - Number of Bookstore_Book__c records to be retrieved from database (We want different amount on VF page and LWC page)
     */
    public void getBookstoreBooks(Id bookstorePublisherForDeleteId, Integer recordLimit) {
        // Selecor to retrieve the Bookstore_Publisher__c record
        BookstorePublisherSelector selector = (BookstorePublisherSelector) new ObjectFactory()
            .createObject(BookstorePublisherSelector.class);
        Bookstore_Publisher__c bookstorePublisherForDelete = selector.getRecordById(bookstorePublisherForDeleteId);

        // Retrieve all the Bookstore_Book__c records that correspond to the same bookstore as the Bookstore_Publisher__c record
        BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory()
            .createObject(BookstoreBookSelector.class);
        List<Bookstore_Book__c> bookstoreBooks = bookstoreBookSelector.getListByBookstoreId(bookstorePublisherForDelete.Bookstore__c, recordLimit);
        
        // Loop through deleted record and retrieved Bookstore__Book__c and check if the Publisher corresponds to the deleted records
        List<Bookstore_Book__c> bookstoreBookRecordsThatCauseError = new List<Bookstore_Book__c>();
        for (Bookstore_Book__c bookstoreBook : bookstoreBooks) {
            if (bookstoreBook.Book__r.Publisher__c == bookstorePublisherForDelete.Publisher__c) {
                bookstoreBookRecordsThatCauseError.add(bookstoreBook);
            }
        }

        // Set response
        this.setResponse(bookstoreBookRecordsThatCauseError);
    }
}