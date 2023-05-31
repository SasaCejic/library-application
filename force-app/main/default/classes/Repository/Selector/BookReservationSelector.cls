/**
 * This class is a selector class for Book_Reservation__c object records
 * 
 * @see Book_Reservation__c
 */
public with sharing class BookReservationSelector implements CustomObject{
    /**
     * Get Bookstore_Book__c objects by Ids
     * 
     * @param reservationIds set of Book_Reservation__c Ids
     */
    public List<Book_Reservation__c> getListByIds (Set<Id> reservationIds) {
        return [
            SELECT
                Id,
                CreatedBy.Name,
                CreatedBy.Email
            FROM
                Book_Reservation__c
            WHERE
                Id IN :reservationIds
        ];
    }
}