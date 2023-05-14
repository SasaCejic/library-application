/**
 * Bookstore search service class used to hold business logic for the
 * BookstoreController
 * 
 * @see BookstoreController.cls
 * @see BookstoreSelector.cls
 */
public with sharing class BookstoreSearchService implements CustomObject{
    /**
     * List of Bookstores that will be returned to Controller as a response
     */
    private List<Bookstore__c> response;

    /**
     * Getter method for response property
     * 
     * @return this class's response property value
     */
    public List<Bookstore__c> getResponse() {
        return this.response;
    }

    /**
     * Setter method for response property
     * 
     * @param response List of Bookstores that we want to assign to response field
     */
    public void setResponse(List<Bookstore__c> response) {
        this.response = response;
    }

    /**
     * Call BookstoreSelector to get list of Bookstores
     * If searchKey parameter is null, set it to empty string to avoid errors
     * Trims white spaces and appends joker characters to the searchKey
     * 
     * @param searchKey string value to search names by
     * 
     */
    public void getBookstoresByName(String searchKey) {
        BookstoreSelector BookstoreSelector = (BookstoreSelector) new ObjectFactory().createObject(BookstoreSelector.class);

        if (searchKey==null) {
            searchKey='';
        }

        searchKey='%'+searchKey.trim()+'%';
        this.setResponse(BookstoreSelector.getListByName(searchKey));
    }

}