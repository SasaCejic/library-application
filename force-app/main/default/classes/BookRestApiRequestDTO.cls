/**
 * DTO class for holding data about bookRestApi Rest request
 */
public with sharing class BookRestApiRequestDTO {
    public List<Book__c> bookList;
    public Integer insertOption;
}