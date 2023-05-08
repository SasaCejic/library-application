/*
 * Sends emails based on email list provided
 */
public  class SendEmailsService implements CustomObject{
    /*
     * @param emailList - List of emails to be sent
     */
    public List<Messaging.SendEmailResult> sendMails(List<Messaging.SingleEmailMessage> emailList) {
        Messaging.SendEmailResult[] results;
        if (!emailList.isEmpty()) {
            results = Messaging.sendEmail(emailList);
        }
        return results;
    }
}