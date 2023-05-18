/*
 * Class responsible for stopping delete of Bookstore_Publisher__c record if Bookstore__Book__c record exist assigned to the same Bookstore__c record
 */
public with sharing class BookstorePublsherDeleteValidationService implements CustomObject {
    private List<Bookstore_Book__c> response;

    //Getter
    public List<Bookstore_Book__c> getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(List<Bookstore_Book__c> bookstoreBookList) {
        this.response = bookstoreBookList;
    }

    /*
     * @param deletedRecords - Bookstore_Publisher__c records being deleted
     */
    public void validateBookstorePublisher(List<Bookstore_Publisher__c> deletedRecords) {
        // Set that holds Ids of Bookstore__c records that correspond to the bookstores of deleted records
        Set<Id> bookstoreIds = new Set<Id>();
        // Loop through deleted records and add their Ids to the set
        for (Bookstore_Publisher__c bookstorePublisher : deletedRecords) {
            bookstoreIds.add(bookstorePublisher.Bookstore__c);
        }

        // Retrieve all the Bookstore_Book__c records that correspond to the same bookstores as deleted records
        BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory()
            .createObject(BookstoreBookSelector.class);
        List<Bookstore_Book__c> bookstoreBooks = bookstoreBookSelector.getListByBookstoreIds(bookstoreIds);
        
        // Loop through deleted record and retrieved Bookstore__Book__c and check if the Publisher corresponds to the deleted records
        List<Bookstore_Book__c> bookstoreBookRecordsThatCauseError = new List<Bookstore_Book__c>();
        for (Bookstore_Publisher__c bookstorePublisher : deletedRecords) {
            for (Bookstore_Book__c bookstoreBook : bookstoreBooks) {
                if (bookstoreBook.Book__r.Publisher__c == bookstorePublisher.Publisher__c) {
                    bookstoreBookRecordsThatCauseError.add(bookstoreBook);
                    bookstorePublisher.addError('You have to delete the associated books first');
                }
            }
        } 
        this.setResponse(bookstoreBookRecordsThatCauseError);
    }
}