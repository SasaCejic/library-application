/*
 * Class used for testing service which sends mails based on provided mail list;
 */
@isTest
public with sharing class SendEmailsServiceTest {
    @isTest
    public static void sendMails_willSendMail_ifMailListIsNotEmpty() {
        // create mail
        Messaging.SingleEmailMessage mail = new CreateEmailWithoutTemplateService().createMail( 'testsubject', 'testbody', 'testmail@gmail.com');

        // execute
        List<Messaging.SendEmailResult> result = new SendEmailsService().sendMails(new List<Messaging.SingleEmailMessage>{mail});

        // assert
        Assert.areEqual(1, result.size());
    }

    @isTest
    public static void sendMails_willNotSendMail_ifMailListIsEmpty() {
        // execute
        List<Messaging.SendEmailResult> result = new SendEmailsService().sendMails(new List<Messaging.SingleEmailMessage>{});

        // assert
        Assert.areEqual(0, result.size());
    }
}