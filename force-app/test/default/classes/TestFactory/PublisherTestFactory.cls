/*
* Class used for creating Publisher__c objects only for tests
*/
@isTest
public with sharing class PublisherTestFactory {
    /*
    * @param numOfPublishers - number of Publisher__c objects to be created
    */
    public List<Publisher__c> createPublishers(Integer numOfPublishers) {
        List<Publisher__c> publishersForTest = new List<Publisher__c>();
        for(Integer i = 0; i<numOfPublishers; i++) {
            Publisher__c currentPublisher = new Publisher__c();
            currentPublisher.Name = 'Publisher' + i;
            currentPublisher.Email__c = 'publisher'+ i + '@gmail.com';
            currentPublisher.Phone__c = '015524' + i;
            publishersForTest.add(currentPublisher);
        }
        return publishersForTest;
    }
}