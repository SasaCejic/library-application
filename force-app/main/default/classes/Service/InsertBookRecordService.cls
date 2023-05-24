/*
 * This class is used for inserting Book_Purchase__c record after purchasing digital book
 */
public with sharing class InsertBookRecordService implements CustomObject{
    /*
     * @param bookList - list of books to be inserted
     */
    public void insertBooks(List<Book__c> bookList) { 
        Database.insert(bookList);
    }
}