/*
 * Class used for sending email after user purchases Digital book
 */
public with sharing class SendPurchaseEmailConfirmationService implements CustomObject{
    private List<Messaging.SendEmailResult> response;

    //Getter
    public List<Messaging.SendEmailResult> getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(List<Messaging.SendEmailResult> emailResults) {
        this.response = emailResults;
    }

    /*
     * @param isPurchaseInserted - Boolean indicating if the purchase that the email should be sent for was inserted into the database(if not don't send the email)
     * @param emailAddress - Email address of the user that bought the book
     * @param bookName - Name of the bought book
     * @param bookPrice - Price of the bought book
     */
    public void sendMail(Boolean isPurchaseInserted, String emailAddress, String bookName, String bookPrice) {
        if (!isPurchaseInserted) {
            return;
        }

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
            try {
                List<Messaging.SendEmailResult> results = sendMailService.sendMails(emailList);
                this.setResponse(results);
            } catch (EmailException e){
                String errorMsg = e.getMessage();
                throw new AuraHandledException('Email is invalid, please check your information again.');
            }
        }
    }
}