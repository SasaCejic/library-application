/*
 * Class used for testing service that sends email after users purchased digital book
 */
@isTest
public with sharing class SendPurchaseEmailConfirmationServiceTest {
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
        SendPurchaseEmailConfirmationService service = new SendPurchaseEmailConfirmationService();
        service.sendMail(true, 'testaddress@gmail.com', 'testname', 'testprice');

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
        SendPurchaseEmailConfirmationService service = new SendPurchaseEmailConfirmationService();
        service.sendMail(true, 'testaddress@gmail.com', 'testname', 'testprice');

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
        SendPurchaseEmailConfirmationService service = new SendPurchaseEmailConfirmationService();
        service.sendMail(true, 'testaddress@gmail.com', 'testname', 'testprice');

        // assert
        CreateEmailWithoutTemplateServiceMocker.assertMethodExecutionCount('createMail', 1);
        SendEmailsServiceMocker.assertMethodExecutionCount('sendMails', 1);
    }
}