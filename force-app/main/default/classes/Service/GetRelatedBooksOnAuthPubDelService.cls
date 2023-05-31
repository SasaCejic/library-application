/**
 * Class used for returning Books that failed Author_Publisher__c delete validation
 */
public with sharing class GetRelatedBooksOnAuthPubDelService implements CustomObject{
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
     * @param authorPublisherId - Id of Author_Publisher__c record being deleted
     */
    public void getRelatedBooks(Id authorPublisherId, Integer recordLimit) {
        // Selector to retrieve the Author_Publisher__c record
        AuthorPublisherSelector selector = (AuthorPublisherSelector) new ObjectFactory()
            .createObject(AuthorPublisherSelector.class);
        Author_Publisher__c authorPublisherForDelete = selector.getRecordById(authorPublisherId);

        // Service to validate AuthorPublisherDeletion
        AuthorPublisherDeleteValidationService authorPublisherDeleteValidationService = (AuthorPublisherDeleteValidationService) new ObjectFactory()
            .createObject(AuthorPublisherDeleteValidationService.class);
        authorPublisherDeleteValidationService.validateAuthorPublisher(new List<Author_Publisher__c>{authorPublisherForDelete}, recordLimit);

        // Set response
        this.setResponse(AuthorPublisherDeleteValidationService.getResponse());
    }
}