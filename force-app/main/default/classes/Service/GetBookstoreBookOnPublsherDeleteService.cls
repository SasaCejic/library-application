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
        // Service to return Bookstore_Publisher__c record based on the Id
        ReturnBookstorePublisherBasedOnIdService returnBookstorePublisherService = (ReturnBookstorePublisherBasedOnIdService) new ObjectFactory()
            .createObject(ReturnBookstorePublisherBasedOnIdService.class);
        returnBookstorePublisherService.returnBookstorePublisher(bookstorePublisherId);
        Bookstore_Publisher__c bookstorePublisherForDelete = returnBookstorePublisherService.getResponse();

        // Service to validate bookstorePublisherDeletion
        BookstorePublsherDeleteValidationService bookstorePublisherDeleteValidationService = (BookstorePublsherDeleteValidationService) new ObjectFactory()
            .createObject(BookstorePublsherDeleteValidationService.class);
        bookstorePublisherDeleteValidationService.validateBookstorePublisher(new List<Bookstore_Publisher__c>{bookstorePublisherForDelete}, recordLimit);

        // Set response
        this.setResponse(bookstorePublisherDeleteValidationService.getResponse());
    }
}