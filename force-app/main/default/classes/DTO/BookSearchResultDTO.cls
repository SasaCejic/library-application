/**
 * DTO Class used for returning results of advanced search functionality on book sObjects
 */
public with sharing class BookSearchResultDTO {
    @auraenabled
    public List<Book__c> books { get; set; }
    @auraenabled
    public Integer filteredOutCount {get; set;} 
}