@IsTest
public with sharing class ControllerIntegrationTest {
    @IsTest
    static void getAccounts_willReturnAccounts() {
        // setup
        Account a = new Account(Name = 'TestAccount');
        insert a;

        // execute
        List<Account> accounts = AccountController.getAccounts();

        // assert
        Assert.areEqual(1, accounts.size());
        Assert.areEqual('TestAccount', accounts[0].Name);
    }
}