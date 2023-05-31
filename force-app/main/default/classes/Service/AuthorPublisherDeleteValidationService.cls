/*
 * Class responsible for stopping delete of Author_Publisher__c record if a Book__c record exist with matching Author and Publisher values
 */
public with sharing class AuthorPublisherDeleteValidationService implements CustomObject{
private List<Book__c> response;

    //Getter
    public List<Book__c> getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(List<Book__c> bookList) {
        this.response = bookList;
    }

    /**
     * @param deletedRecords - Author_Publisher__c records being deleted 
     */
    public void validateAuthorPublisher(List<Author_Publisher__c> deletedRecords, Integer recordLimit) {
        // Set that holds Ids of Author__c records that correspond to the Authors of deleted records
        Set<Id> authorIds = new Set<Id>();
        // Loop through deleted records and add their Ids to the set
        for (Author_Publisher__c authorPublisher : deletedRecords) {
            authorIds.add(authorPublisher.Author__c);
        }

        // Retrieve all the Book__c records that correspond to the same Authors as deleted records
        BookSelector bookSelector = (BookSelector) new ObjectFactory()
            .createObject(BookSelector.class);
        List<Book__c> books = bookSelector.getListByAuthorIds(authorIds, recordLimit);
        
        // Loop through deleted record and retrieved Book__c and check if the Publisher corresponds to the deleted records
        List<Book__c> bookRecordsThatCauseError = new List<Book__c>();
        for (Author_Publisher__c authorPublisher : deletedRecords) {
            for (Book__c book : books) {
                if (book.Publisher__c == authorPublisher.Publisher__c) {
                    bookRecordsThatCauseError.add(Book);
                    if (Trigger.isExecuting) {
                        system.debug(authorPublisher);
                        authorPublisher.addError('You have to delete the associated books first');
                    }
                }
            }
        }
        this.setResponse(bookRecordsThatCauseError);
    }
}