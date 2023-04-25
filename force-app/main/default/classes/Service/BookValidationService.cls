/*
* Validates if the Book__c sObject that is being created/edited has matching Author__c and Publisher__c values
* (wether an Author_Publisher__c junction sObject with matching Author__c and Publisher__c values exists)
*/
public with sharing class BookValidationService implements CustomObject{
    /*
    * @param newBooks - Newly added or edited books
    */
    public void validateAuthorPublisherMatch(List<Book__c> newBooks) {
        //Get all Author_Publisher__c sObjects
        AuthorPublisherSelector authorPublisherSelector = (AuthorPublisherSelector) new ObjectFactory().createObject(AuthorPublisherSelector.class);
        List<Author_Publisher__c> authorPublishers = authorPublisherSelector.getList();

        //Iterate through each new book
        //For each new book, iterate through Author_Publisher__c sObjects, checking if one with matching Author__c and Publisher__c fields is found
        //If matching Author_Publisher__c is not found, add error to the invalid Book__c sObject
        for (Book__c newBook:newBooks){
            Boolean isFound=false;           
            for(Author_Publisher__c authorPublisher:authorPublishers){
                if (newBook.Author__c==authorPublisher.Author__c && newBook.Publisher__c==authorPublisher.Publisher__c){
                    isFound=true;
                    break;
                }
            }
            if (!isFound) {
                newBook.addError('Book author and book publisher must work together!');
            }
        }
    }
}