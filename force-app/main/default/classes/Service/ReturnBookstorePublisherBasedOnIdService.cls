/**
 * Service returns Bookstore_Publisher__c record based on Id provided
 */
public with sharing class ReturnBookstorePublisherBasedOnIdService implements CustomObject {
    private Bookstore_Publisher__c response;

    //Getter
    public Bookstore_Publisher__c getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(Bookstore_Publisher__c bookstorePublisher) {
        this.response = bookstorePublisher;
    }

    /**
     * @param bookstorePublisherId - Id of the Bookstore_Publisher__c record
     */
    public void returnBookstorePublisher(Id bookstorePublisherId) {
        // Selecor to retrieve the Bookstore_Publisher__c record
        BookstorePublisherSelector selector = (BookstorePublisherSelector) new ObjectFactory()
            .createObject(BookstorePublisherSelector.class);
        this.setResponse(selector.getRecordById(bookstorePublisherId));
    }
}