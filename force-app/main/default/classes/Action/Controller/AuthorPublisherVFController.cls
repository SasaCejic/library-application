/**
 * Class used as Author_Publisher__c controller for both AuthorPublisherDeleteOvrried VF page
 */
public with sharing class AuthorPublisherVFController {
// Id of the Author_Publisher__c record being deleted
    private Id recordId { get; set; }
    // Author_Publisher__c record for delete
    private Author_Publisher__c authorPublisherForDelete { get; set; }
    // Boolean indicating if Canceled button was clicked
    private Boolean isCanceled { get; set; }
    // Boolean indicating if the viewAllButton was clicked
    private Boolean isViewAllClicked { get; set; }
    // Boolean indicating if the confirm button was clicked was clicked
    public Boolean isConfirmClicked{ get; set; }
    // Boolean indicating if delete failed
    public Boolean didDeleteFail { get; set; }

    /**
     * Constructor that sets recordId and Author_Publisher__c record for deletion
     * @param controller - Standard controller
     */
    public AuthorPublisherVFController(ApexPages.StandardController controller) {
        isCanceled = false;
        isViewAllClicked = false;
        recordId = controller.getId();
        isViewAllClicked = false;
        didDeleteFail = false;
        setAuthorPublihserForDelete();
    }

    /**
     * Method that returns the Author_Publisher__c record based on its id
     */
    private void setAuthorPublihserForDelete() {
        // Selector to retrieve the Author_Publisher__c record
        AuthorPublisherSelector selector = (AuthorPublisherSelector) new ObjectFactory()
            .createObject(AuthorPublisherSelector.class);
        authorPublisherForDelete = selector.getRecordById(recordId);
    }

    /**
     * Getter that will return first 5 Book__c records causing the deletion to fail
     */
    public List<Book__c> getBooksCausingError() {
        GetRelatedBooksOnAuthPubDelService service = (GetRelatedBooksOnAuthPubDelService) new ObjectFactory()
            .createObject(GetRelatedBooksOnAuthPubDelService.class);
        service.getRelatedBooks(recordId, 5);
        return service.getResponse();
    }

    /**
     * Method that will return corresponding PageReference based on the state of the controller
     */
    public PageReference getPageReference() {
        PageReferenceService service = (PageReferenceService) new ObjectFactory()
            .createObject(PageReferenceService.class);
        service.getPageReferenceForAuthorPublisher(isCanceled, isViewAllClicked, didDeleteFail, authorPublisherForDelete);
        return service.getResponse();
    }

    /**
     * Delete override. First tries to delete the record, if it fails, displays the table of records that caused it to fail
     */
    public void deleteRecord() {
        isConfirmClicked = true;
        DeleteAuthorPublisherRecordService deleteService = (DeleteAuthorPublisherRecordService) new ObjectFactory()
            .createObject(DeleteAuthorPublisherRecordService.class);
        deleteService.deleteAuthorPublisher(recordId);
        didDeleteFail = !deleteService.getResponse().isSuccess();
    }

    /**
     * Cancel override functionality that redirects to the Publisher page from where delete button was clicked
     */
    public PageReference cancel() {
       isCanceled = true;
       return getPageReference();
    }

    /**
     * Method redirects user to page where they can see all Publisher books causing delete to fail
     */
    public Pagereference viewAll() {
        isViewAllClicked = true;
        return getPageReference();
    }
}