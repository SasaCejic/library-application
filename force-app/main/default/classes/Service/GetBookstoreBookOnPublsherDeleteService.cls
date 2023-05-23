/**
 * Class used for returning Bookstore Books that failed publisher delete validation
 */
public with sharing class GetBookstoreBookOnPublsherDeleteService implements CustomObject {
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
     * @param bookstorePublisherId - Id of Bookstore_Publisher__c record being deleted
     */
    public void getBookstoreBooks(Id bookstorePublisherId, Integer recordLimit) {
        // Selector to retrieve the Bookstore_Publisher__c record
        BookstorePublisherSelector selector = (BookstorePublisherSelector) new ObjectFactory()
            .createObject(BookstorePublisherSelector.class);
        Bookstore_Publisher__c bookstorePublisherForDelete = selector.getRecordById(bookstorePublisherId);

        // Service to validate bookstorePublisherDeletion
        BookstorePublsherDeleteValidationService bookstorePublisherDeleteValidationService = (BookstorePublsherDeleteValidationService) new ObjectFactory()
            .createObject(BookstorePublsherDeleteValidationService.class);
        bookstorePublisherDeleteValidationService.validateBookstorePublisher(new List<Bookstore_Publisher__c>{bookstorePublisherForDelete}, recordLimit);

        // Set response
        this.setResponse(bookstorePublisherDeleteValidationService.getResponse());
    }
}