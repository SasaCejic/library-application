/**
 * This is the service class for BookObject
 */
public with sharing class BookService implements CustomObject{
    /**
     * Book__c object that will be returned o controler as a response
     */
    private Book__c response;

    /**
     * Getter method for response property
     * 
     * @return this class's response property value
     */
    public Book__c getResponse() {
        return this.response;
    }

    /**
     * Setter method for response property
     * 
     * @param response Book__c object that we want to assign to response field
     */
    public void setResponse(Book__c response) {
        this.response = response;
    }

    /**
     * Call BookSelector to get a Book__c object record with passed Id parameter
     * 
     * @param bookId Id of a book we are looking for
     * 
     */
    public void getBookById(Id bookId) {
        if (bookId == null) {
            this.setResponse(null);
        } else {
            BookSelector bookSelector = (BookSelector) new ObjectFactory().createObject(BookSelector.class);
            this.setResponse(bookSelector.getBookById(bookId));
        }
    }
}