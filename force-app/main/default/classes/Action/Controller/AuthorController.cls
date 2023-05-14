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
    public static List<Bookstore__c> getBookstoresWithAuthorsBooks(Id authorId) {
        AuthorService service = (AuthorService) new ObjectFactory().createObject(AuthorService.class);

        service.getBookstoresWithAuthorsBooks(authorId);

        return service.getResponse();
    }

    /**
     * Call AuthorSearchService class method to get
     * all Author__c records with names containing the specified searchKey
     * 
     * @param searchKey string value to search names by
     * 
     * @return list of Author__c object records
     */
    @AuraEnabled(cacheable = true)
    public static List<Author__c> getAuthorsByName(Id searchKey) {
        AuthorSearchService service = (AuthorSearchService) new ObjectFactory().createObject(AuthorSearchService.class);

        service.getAuthorsByName(searchKey);

        return service.getResponse();
    }
}