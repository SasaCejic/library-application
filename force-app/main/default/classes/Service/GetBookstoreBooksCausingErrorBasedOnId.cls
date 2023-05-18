/**
 * Class returns a list of Bookstore_Book__c records causing the deletion of Bookstore_Publisher__c record with given Id to fail
 */
public with sharing class GetBookstoreBooksCausingErrorBasedOnId {
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
     * @param bookstorePublisherId - Id of Bookstore_Publisher__c record that is being deleted
     */
    public void getBookstoreBooks(Id bookstorePublisherId) {
        // Selecor to retrieve the Bookstore_Publisher__c record being deleted
        BookstorePublisherSelector selector = (BookstorePublisherSelector) new ObjectFactory()
            .createObject(BookstorePublisherSelector.class);
        Bookstore_Publisher__c bookstorePublisherForDelete = selector.getRecordById(bookstorePublisherId);

        // Service for retrieving list of Bookstore_Book__c records causing delete to fail
        BookstorePublsherDeleteValidationService service = (BookstorePublsherDeleteValidationService) new ObjectFactory()
            .createObject(BookstorePublsherDeleteValidationService.class);
        service.validateBookstorePublisher(new List<Bookstore_Publisher__c>{ bookstorePublisherForDelete });

        // set response
        this.setResponse(service.getResponse());
    }
}