/*
 * Class used to validate if the same purchase already exists
 * Class will perform 2 validations, First one checks if in the list of new purchases there are 2 same, and will result in an error
 * Other validation will check if in the database there are any purchases that are the same and will result in an error
 */
public with sharing class BookPurchaseValidationService implements CustomObject {
    /*
     * @param newRecords - records being inserted into the database
     */
    public void validatePurchase(List<Book_Purchase__c> newPurchases) {
        //Set to store all bookIds present in new purchases
        Set<Id> booksIds = new Set<Id>();
        // Check if in the new added purchases there are 2 same ones(CreatedById is not checked since it is not writeable and can only have the Id of current user)
        // Meaning that there can never be multiple new purchases at once from different users
        for (Book_Purchase__c purchase:newPurchases) {
            if (booksIds.contains(purchase.Book__c)) {
                purchase.addError('You can only purchase the book once!');
                return;
            }
            booksIds.add(purchase.Book__c);
        }
        // Now check if there are any same purchases in the database
        BookPurchaseSelector bookPurchaseSelector = (BookPurchaseSelector) new ObjectFactory()
            .createObject(BookPurchaseSelector.class);
        List<Book_Purchase__c> existingBookPurchases = bookPurchaseSelector.getList();
        for (Book_Purchase__c purchase: existingBookPurchases) {
            for (Book_Purchase__c newPurchase: newPurchases) {
                if (newPurchase.Book__c == purchase.Book__c && UserInfo.getUserId() == purchase.CreatedById) {
                    newPurchase.addError('You can only buy one digital copy of a book!');
                }
            }
        }
    }
}