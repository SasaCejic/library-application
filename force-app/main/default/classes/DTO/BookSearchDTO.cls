/**
 * DTO Class used for performing advanced search functionality on book sObjects
 */
public with sharing class BookSearchDTO {
    @auraenabled
    public String name { get; set; }
    @auraenabled
    public String ISBN { get; set; }
    @AuraEnabled
    public Id author { get; set; }
    @AuraEnabled
    public Date publishDate { get; set; }
    @AuraEnabled
    public Id bookstore { get; set; }
    @AuraEnabled
    public Id publisher { get; set; }
    @AuraEnabled
    public List<String> categories { get; set; }
    @AuraEnabled
    public List<String> languages { get; set; }
    @AuraEnabled
    public Decimal price { get; set; }
    @AuraEnabled
    public Decimal reviewScore { get; set; }
    @AuraEnabled
    public String term { get; set; }

}