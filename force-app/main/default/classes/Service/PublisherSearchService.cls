/**
 * Publisher search service class used to hold business logic for the
 * PublisherController
 * 
 * @see PublisherController.cls
 * @see PublisherSelector.cls
 */
public with sharing class PublisherSearchService implements CustomObject {
/**
     * List of Publishers that will be returned to Controller as a response
     */
    private List<Publisher__c> response;

    /**
     * Getter method for response property
     * 
     * @return this class's response property value
     */
    public List<Publisher__c> getResponse() {
        return this.response;
    }

    /**
     * Setter method for response property
     * 
     * @param response List of Publishers that we want to assign to response field
     */
    public void setResponse(List<Publisher__c> response) {
        this.response = response;
    }

    /**
     * Call PublisherSelector to get list of Publishers
     * If searchKey parameter is null, set it to empty string to avoid errors
     * Trims white spaces and appends joker characters to the searchKey
     * 
     * @param searchKey string value to search names by
     * 
     */
    public void getPublishersByName(String searchKey) {
        PublisherSelector publisherSelector = (PublisherSelector) new ObjectFactory().createObject(PublisherSelector.class);

        if (searchKey==null) {
            searchKey='';
        }

        searchKey='%'+searchKey.trim()+'%';
        this.setResponse(publisherSelector.getListByName(searchKey));
    }
}