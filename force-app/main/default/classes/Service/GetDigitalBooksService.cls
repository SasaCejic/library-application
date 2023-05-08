/*
 * Class used as a service for getting all digital books
 */
public with sharing class GetDigitalBooksService implements CustomObject{
    private List<Book__c> response;

    //Getter
    public List<Book__c> getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(List<Book__c> bookList) {
        this.response = bookList;
    }
    
    /*
     * Method gets record type id of a digital book and retrieves all digital books using book selector
     */
    public void getBooks(String searchTerm) {
        Id digitalBookRecordTypeId = Schema.SObjectType.Book__c.getRecordTypeInfosByName()
            .get('Digital Book').getRecordTypeId();
        BookSelector bookSelector = (BookSelector) new ObjectFactory()
            .createObject(BookSelector.class);
        searchTerm = searchTerm.trim();
        searchTerm = '%' + searchTerm + '%';
        this.setResponse(bookSelector.getDigitalBooksList(digitalBookRecordTypeId, searchTerm));
    }
}