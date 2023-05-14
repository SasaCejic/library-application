/**
 * Author search service class used to hold business logic for the
 * AuthorController
 * 
 * @see AuthorController.cls
 * @see AuthorSelector.cls
 */
public with sharing class AuthorSearchService implements CustomObject{
    /**
     * List of Authors that will be returned to Controller as a response
     */
    private List<Author__c> response;

    /**
     * Getter method for response property
     * 
     * @return this class's response property value
     */
    public List<Author__c> getResponse() {
        return this.response;
    }

    /**
     * Setter method for response property
     * 
     * @param response List of Authors that we want to assign to response field
     */
    public void setResponse(List<Author__c> response) {
        this.response = response;
    }

    /**
     * Call AuthorSelector to get list of Authors
     * If searchKey parameter is null, set it to empty string to avoid errors
     * Trims white spaces and appends joker characters to the searchKey
     * 
     * @param searchKey string value to search names by
     * 
     */
    public void getAuthorsByName(String searchKey) {
        AuthorSelector authorSelector = (AuthorSelector) new ObjectFactory().createObject(AuthorSelector.class);

        if (searchKey==null) {
            searchKey='';
        }

        searchKey='%'+searchKey.trim()+'%';
        this.setResponse(authorSelector.getListByName(searchKey));
    }
}