/**
 * This class performs unit tests for BookReservationTriggerHanldler class
 * 
 * @see BookReservationTriggerHandler.cls
 */
@isTest
public with sharing class BookReservationTriggerHandlerTest {
    @isTest
    public static void beforeInsert_WillUseService() {
        //disable trigger unrelated to test
        BookReservationTriggerHandler.triggerDisabled=true;

        // create mock
        Mocker bookReservationValidationServiceMock = new Mocker(BookReservationValidationService.class)
        .setBehavior('validateSelectedBook', new List<Book_Reservation__c>());
        ObjectFactory.mocks.put(
            BookReservationValidationService.class.getName(),
            (BookReservationValidationService)bookReservationValidationServiceMock.getMock()
        );

        // execute
        BookReservationTriggerHandler bookReservationTriggerHandler = new BookReservationTriggerHandler();
        bookReservationTriggerHandler.beforeInsert(new List<Book_Reservation__c>{});
        
        //assert
        bookReservationValidationServiceMock.assertMethodExecutionCount('validateSelectedBook', 1);
    }

    @isTest
    public static void beforeUpdate_WillUseService() {
         //disable triger unrelated to test
         BookReservationTriggerHandler.triggerDisabled=true;
         
         // create mock
         Mocker bookReservationValidationServiceMock = new Mocker(BookReservationValidationService.class)
        .setBehavior('validateSelectedBook', new List<Book_Reservation__c>());
        ObjectFactory.mocks.put(
            BookReservationValidationService.class.getName(),
            (BookReservationValidationService)bookReservationValidationServiceMock.getMock()
        );
 
         // execute
         BookReservationTriggerHandler bookReservationTriggerHandler = new BookReservationTriggerHandler();
         bookReservationTriggerHandler.beforeUpdate(new List<Book_Reservation__c>{}, new List<Book_Reservation__c>{});
         
         //assert
         bookReservationValidationServiceMock.assertMethodExecutionCount('validateSelectedBook', 1);
    }
}