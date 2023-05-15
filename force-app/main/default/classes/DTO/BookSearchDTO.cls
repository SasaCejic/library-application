public with sharing class BookSearchDTO {
    @auraenabled
    public string Name { get; set; }
    @auraenabled
    public integer ISBN { get; set; }
    @AuraEnabled
    public Id author { get; set; }
    @AuraEnabled
    public Date publishDate { get; set; }
    @AuraEnabled
    public Id bookstore { get; set; }

}