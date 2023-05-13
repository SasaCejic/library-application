/**
 * Class used to send email after user makes a paper book reservation
 */
public with sharing class SendReservationEmailConfirmationService implements CustomObject{
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
     * @param bookName - Name of the reserved book
     * @param quantity - Number of reserved books
     * @param totalPrice - Total price of the reservation
     */
    public void sendMail(String emailAddress, String bookName, Integer quantity, Decimal totalPrice) {
    
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        // create the mail
        String emailSubject = 'Book Reservation confirmation mail';
        String emailBody = 'Dear ' + UserInfo.getFirstName() + '\n' + 'You made a reservation for ' + bookName + '\n' + 'Quantity: ' + quantity + '\n' + 'Total price: ' + totalPrice + '$';
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