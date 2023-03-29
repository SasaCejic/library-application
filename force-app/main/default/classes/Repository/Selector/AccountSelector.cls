public with sharing class AccountSelector implements CustomObject {
    public List<Account> getAccounts() {
        return [
            SELECT
                Id
            FROM
                Account
        ];
    }
}