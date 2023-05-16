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
     * @param bookQueryConditions - string containing SOQL conditions and limit for book search
     * @param bookstoreQueryConditions - string containing SOQL conditions for related bookstore records
     * @param paginationQueryConditions - string containing SOQL conditions to pagination
     */
    public List<AggregateResult> getAggregateResultFromQueryConditions(String bookQueryConditions, String bookstoreQueryConditions, String paginationQueryConditions) {
        //DODAJ ZA PRICE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        String queryString = 'SELECT Id, Name, ISBN__c, Author__r.Name, Publish_Date__c,'+
            ' (select Bookstore__c, Bookstore__r.Name from Bookstore_Book__r {0}), Categories__c, Language__c, Description__c'+
            ' FROM Book__c {1} GROUP BY Id {2}';
        queryString = String.format(queryString, new String[] {bookstoreQueryConditions, bookQueryConditions, paginationQueryConditions});
        return Database.query(queryString, AccessLevel.USER_MODE);
    }
}