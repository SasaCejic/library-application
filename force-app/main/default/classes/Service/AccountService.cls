public with sharing class AccountService implements CustomObject {
    public List<Account> getAccounts() {
        AccountSelector selector = (AccountSelector) new ObjectFactory().createObject(AccountSelector.class);

        return selector.getAccounts();
    }
}