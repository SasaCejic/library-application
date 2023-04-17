/*
* Class used for testing the class that creates publisher objects used only in tests written for other classes
*/
@isTest
public with sharing class PublisherTestFactoryTest {
    @isTest
    public static void createPublishers_willCreateFivePublishers() {
        Test.startTest();
        List<Publisher__c> publishersForTest = new PublisherTestFactory().createPublishers(5);
        Test.stopTest();
        System.assertEquals(5, publishersForTest.size());
    }
}