/*
 *Class returns mail based on email body, subject and address
 */
public class CreateEmailWithoutTemplateService implements CustomObject{
    /*
     * Method returns SingleEmailMessage intended to be sent via SendEmailService
     * @param emailSubject - Subject of the email
     * @param emailBody - Body of the email
     * @param emailAddress - Email address
     */
    public Messaging.SingleEmailMessage createMail(String emailSubject, String emailBody, String emailAddress) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject(emailSubject);
        mail.setPlainTextBody(emailBody);
        mail.setToAddresses(new String[] {emailAddress});
        return mail;
    }
}