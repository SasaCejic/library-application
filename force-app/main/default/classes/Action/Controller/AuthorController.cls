/**
 * Author controller class used to call certain Author service
 * 
 * @see AuthorService.cls
 */
public with sharing class AuthorController {

    /**
     * Call AuthorService class method to get
     * all Bookstore__c records with certain
     * author's books
     * 
     * @param authorId certain author id
     * 
     * @return list of Bookstore__c object records
     */
    @AuraEnabled(cacheable = true)
    public static List<Bookstore__c> getBookstoresWithAuthorsBooks(Id authorId){
        AuthorService service = (AuthorService) new ObjectFactory().createObject(AuthorService.class);

        return service.getBookstoresWithAuthorsBooks(authorId);
    }
}