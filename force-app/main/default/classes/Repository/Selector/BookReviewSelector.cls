/*
 * Class used for selecting book reviews from database
 */
public with sharing class BookReviewSelector implements CustomObject {
    /*
     * Method used for retrieving all book reviews from the database
     */
    public List<Book_Review__c> getList() {
        return [
            SELECT
                Id,
                Book__c,
                CreatedById
            FROM Book_Review__c
        ];
    }

    /*
     * Method used for retrieving average review rating for a set of specified book ids
     * 
     * @param bookIds - set of book Ids for which average raitng should be be retrieved
     */
    public List<AggregateResult> getAverageRatingListByBookIdSet(Set<Id> bookIds) {
        return [
            SELECT
                Book__c,
                AVG(Rating_Number__c) Rating
            FROM Book_Review__c
            WHERE Book__c=:bookIds
            GROUP BY Book__c
        ];
    }
}