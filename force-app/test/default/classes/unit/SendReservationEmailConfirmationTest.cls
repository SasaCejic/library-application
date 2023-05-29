/**
 * This class tests service that sends an email after the user reserve
 * a paper book
 * 
 * @see SendReservationEmailConfirmationService.cls
 */
@isTest
public with sharing class SendReservationEmailConfirmationTest {
    @isTest
    public static void sendMail_willNotSendMail_ifEmailWasNotCreated() {
        // create mocks
        Mocker CreateEmailWithoutTemplateServiceMocker = new Mocker(CreateEmailWithoutTemplateService.class)
            .setBehavior('createMail', null);
        ObjectFactory.mocks.put(
            CreateEmailWithoutTemplateService.class.getName(),
            (CreateEmailWithoutTemplateService)CreateEmailWithoutTemplateServiceMocker.getMock()
        );
        List<Messaging.SendEmailResult> emailsSentForMock = new List<Messaging.SendEmailResult>();
        Mocker SendEmailsServiceMocker = new Mocker(SendEmailsService.class)
            .setBehavior('sendMails', emailsSentForMock);
        ObjectFactory.mocks.put(
            SendEmailsService.class.getName(),
            (SendEmailsService)SendEmailsServiceMocker.getMock()
        );
        
        // execute
        SendReservationEmailConfirmationService service = new SendReservationEmailConfirmationService();
        service.sendMail('testaddress@gmail.com', 'Paper Book', 2, 22.99);

        // assert
        Assert.areEqual(0, service.getResponse().size());
    }

    @isTest
    public static void sendMail_willSendMail_ifEmailWasCreated() {
         // create mocks
        Messaging.SingleEmailMessage mailForMock = new  Messaging.SingleEmailMessage();
        Mocker CreateEmailWithoutTemplateServiceMocker = new Mocker(CreateEmailWithoutTemplateService.class)
            .setBehavior('createMail', mailForMock);
        ObjectFactory.mocks.put(
            CreateEmailWithoutTemplateService.class.getName(),
            (CreateEmailWithoutTemplateService)CreateEmailWithoutTemplateServiceMocker.getMock()
        );
        List<Messaging.SendEmailResult> emailsSentForMock = new List<Messaging.SendEmailResult>{};
        Mocker SendEmailsServiceMocker = new Mocker(SendEmailsService.class)
            .setBehavior('sendMails', emailsSentForMock);
        ObjectFactory.mocks.put(
            SendEmailsService.class.getName(),
            (SendEmailsService)SendEmailsServiceMocker.getMock()
        );
        
        // execute
        SendReservationEmailConfirmationService service = new SendReservationEmailConfirmationService();
        service.sendMail('testaddress@gmail.com', 'Paper Book', 2, 22.99);

        // assert
        // Messaging.SendEmailResult does not have a public constructor, thus creating mocked value for it seems to not be possible
        // Workaround is testing the method execution for SendEmailsServiceMocker. If mail was created, SendEmailService will be executed
        SendEmailsServiceMocker.assertMethodExecutionCount('sendMails', 1);
    }

    @isTest
    public static void sendMail_willUseCorrectServices() {
        // create mocks 
        Messaging.SingleEmailMessage mailForMock = new  Messaging.SingleEmailMessage();
        Mocker CreateEmailWithoutTemplateServiceMocker = new Mocker(CreateEmailWithoutTemplateService.class)
            .setBehavior('createMail', mailForMock);
        ObjectFactory.mocks.put(
            CreateEmailWithoutTemplateService.class.getName(),
            (CreateEmailWithoutTemplateService)CreateEmailWithoutTemplateServiceMocker.getMock()
        );
        List<Messaging.SendEmailResult> emailsSentForMock = new List<Messaging.SendEmailResult>();
        Mocker SendEmailsServiceMocker = new Mocker(SendEmailsService.class)
            .setBehavior('sendMails', emailsSentForMock);
        ObjectFactory.mocks.put(
            SendEmailsService.class.getName(),
            (SendEmailsService)SendEmailsServiceMocker.getMock()
        );
        
        // execute
        SendReservationEmailConfirmationService service = new SendReservationEmailConfirmationService();
        service.sendMail('testaddress@gmail.com', 'Paper Book', 2, 22.99);

        // assert
        CreateEmailWithoutTemplateServiceMocker.assertMethodExecutionCount('createMail', 1);
        SendEmailsServiceMocker.assertMethodExecutionCount('sendMails', 1);
    }


}