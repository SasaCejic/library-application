public with sharing class AuthorController {
    @AuraEnabled(cacheable = true)
    public static List<Bookstore__c> getBookstoresWithAuthorsBooks(Id authorId){
        AuthorService service = (AuthorService) new ObjectFactory().createObject(AuthorService.class);

        return service.getBookstoresWithAuthorsBooks(authorId);
    }
}