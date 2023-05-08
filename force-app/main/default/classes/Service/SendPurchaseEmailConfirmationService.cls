/*
 * Class used for sending email after user purchases Digital book
 */
public with sharing class SendPurchaseEmailConfirmationService implements CustomObject{
    /*
     * @param emailAddress - Email address of the user that bought the book
     * @param bookName - Name of the bought book
     * @param bookPrice - Price of the bought book
     */
    public void sendMail(String emailAddress, String bookName, String bookPrice) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        // create the mail
        String emailSubject = 'Purchased book information';
        String emailBody = 'Dear ' + UserInfo.getFirstName() + '\n' + 'You bought ' + bookName + '\n' + 'Price: ' + bookPrice + '$';
        CreateEmailWithoutTemplateService createEmailService = (CreateEmailWithoutTemplateService) new ObjectFactory()
            .createObject(CreateEmailWithoutTemplateService.class);
        Messaging.SingleEmailMessage mail = createEmailService.createMail(emailSubject,emailBody,emailAddress);
        // add it to the list to be sent
        emailList.add(mail);
        // Send the email
        if (emailList.size() !=0 ) {
            SendEmailsService sendMailService = (SendEmailsService) new ObjectFactory()
                .createObject(SendEmailsService.class);
            List<Messaging.SendEmailResult> results = sendMailService.sendMails(emailList);
            for (Messaging.SendEmailResult result:results) {
                if (result.isSuccess()) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('An error occurred while sending the email: ' + result.getErrors());
                }
            }
        }
    }
}