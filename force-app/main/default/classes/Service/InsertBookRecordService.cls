/*
 * This class is used for inserting Book_Purchase__c record after purchasing digital book
 */
public with sharing class InsertBookRecordService implements CustomObject{
    private List<Database.SaveResult> response;

    //Getter
    public List<Database.SaveResult> getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(List<Database.SaveResult> booksInsert) {
        this.response = booksInsert;
    }
    
    /*
     * @param bookId - Id of the book purchased
     * The id of the user will be documented as createdById since only the users that are buying the book can insert this object
     */
    public void insertBooks(List<Book__c> bookList) { 
        List<Database.SaveResult> insertionResult = Database.insert(bookList, false);
        this.setResponse(insertionResult);
    }
}