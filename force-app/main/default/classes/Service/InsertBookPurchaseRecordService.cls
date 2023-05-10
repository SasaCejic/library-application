/*
 * This class is used for inserting Book_Purchase__c record after purchasing digital book
 */
public with sharing class InsertBookPurchaseRecordService implements CustomObject{
    private Database.SaveResult response;

    //Getter
    public Database.SaveResult getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(Database.SaveResult purchaseInsert) {
        this.response = purchaseInsert;
    }
    
    /*
     * @param bookId - Id of the book purchased
     * The id of the user will be documented as createdById since only the users that are buying the book can insert this object
     */
    public void insertPurchase(Id bookId) { 
        Book_Purchase__c purchase = new Book_Purchase__c();
        purchase.Book__c = bookId;
        Database.SaveResult insertResult = Database.insert(purchase);
        this.setResponse(insertResult);
    }
}