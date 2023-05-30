/**
 * This class is used to send and email to customer after his book reservation revert period
 * expires
 */
public with sharing class SendCancelationEmailConfirmationService implements CustomObject{
    private List<Messaging.SendEmailResult> response;

    //Getter
    public List<Messaging.SendEmailResult> getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(List<Messaging.SendEmailResult> emailResults) {
        this.response = emailResults;
    }

    /**
     * @param emailAddress - Email address of the user that reserved the book
     * @param reservationNumber - Book Reservation number
     * @param userName - Name of the user who created the reservation
     */
    public void sendMail(String emailAddress, String reservationNumber, String userName) {
    
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        // create the mail
        String emailSubject = 'Book Reservation cancelation mail';
        String emailBody = 'Dear ' + userName + ',\n' + 'Revert period for your reservation ' + reservationNumber + 'has expired and the reservation is canceled.';
        CreateEmailWithoutTemplateService createEmailService = (CreateEmailWithoutTemplateService) new ObjectFactory()
            .createObject(CreateEmailWithoutTemplateService.class);
        Messaging.SingleEmailMessage mail = createEmailService.createMail(emailSubject,emailBody,emailAddress);
        // add it to the list to be sent
        emailList.add(mail);

        // Send the email
        if (emailList.size() !=0 ) {
            SendEmailsService sendMailService = (SendEmailsService) new ObjectFactory()
                .createObject(SendEmailsService.class);
            try{
                List<Messaging.SendEmailResult> results = sendMailService.sendMails(emailList);
                this.setResponse(results);
            } catch (EmailException e){
                String errorMsg = e.getMessage();
                throw new AuraHandledException('Email is invalid, please check your information again.');
            }
        }
    }

}