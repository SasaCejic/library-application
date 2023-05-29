/*
 * Class performs database selectors for Book__c objects
 */
public with sharing class BookSelector implements CustomObject {
    /*
     * Method returns a map of added bookstoreBooks and their publishers
     * @param BookId - Id of the book being retrieve
     */
    public Map<Id, Book__c> getMapByIds(Set<Id> bookIds) {
        return new Map<Id, Book__c>([
            SELECT
                Id,
                Publisher__c
            FROM Book__c
            WHERE Id In :bookIds
        ]);
    }
    
    /*
     * @param bookIds - set of book Ids which should not be retrieved
     */
    public List<Book__c> getListNotInIds(Set<Id> bookIds, Integer recordLimit) {
        return [
            SELECT
                Id,
                Name,
                ISBN__c
            FROM Book__c
            WHERE Id NOT IN :bookIds
            LIMIT :recordLimit
        ];
    }

    /*
     * @param bookQueryConditions - string containing SOQL conditions, limit and offset for book search
     */
    public List<Book__c> getListFromQueryConditions(String bookQueryConditions) {
        String queryString = 'SELECT Id, Name, ISBN__c, Author__r.Name, Publish_Date__c, Price__c,'+
            ' (select Bookstore__c, Bookstore__r.Name from Bookstore_Books__r), Categories__c, Language__c, Description__c'+
            ' FROM Book__c {0}';
        queryString = String.format(queryString, new String[] {bookQueryConditions});
        return Database.query(queryString, AccessLevel.USER_MODE);
    }

    /**
     * Get Book__c record by it's ID value
     * 
     * @param bookId id of the book we are looking for
     */
    public Book__c getBookById (Id bookId) {
        return [
            SELECT
                Name,
                Price__c
            FROM
                Book__c
            WHERE Id = :bookId
            LIMIT 1
        ];
    }

    /**
     * @param bookISBNs - set of book ISBNs to retrieve books
     */
    public list<Book__c> getListByISBNs(Set<String> setOfISBNs) {
        return [
            SELECT
                Id,
                Name,
                ISBN__c
            FROM Book__c
            WHERE ISBN__c IN :setOfISBNs
        ];
    }
}