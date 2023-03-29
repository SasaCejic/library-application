public with sharing class AccountController {
    @AuraEnabled(Cacheable=true)
    public static List<Account> getAccounts() {
        AccountService service = (AccountService) new ObjectFactory().createObject(
            AccountService.class.getName()
        );

        return service.getAccounts();
    }
}