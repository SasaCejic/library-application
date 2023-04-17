/*
* Class used for creating Bookstore__c objects only for tests
*/
@isTest
public with sharing class BookstoreTestFactory {
    /*
    * @param numOfBookstores - number of Bookstore__c objects to be inserted
    */
    public List<Bookstore__c> createBookstores(Integer numOfBookstores) {
        List<Bookstore__c> bookstoresForTest = new List<Bookstore__c>();
        for(Integer i = 0;i<numOfBookstores; i++) {
            Bookstore__c currentBookstore = new Bookstore__c();
            currentBookstore.Name = 'Bookstore' + i;
            currentBookstore.Email__c = 'bookstore' + i + '@gmail.com';
            currentBookstore.Store_Identification_Code__c = '12i245' + i;
            bookstoresForTest.add(currentBookstore);
        }
        return bookstoresForTest;
    }
}