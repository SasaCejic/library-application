@IsTest
public with sharing class AccountServiceTest {
    @IsTest
    static void getAccount_willUseSelector() {
        // create mock
        Mocker mock = new Mocker(AccountSelector.class)
            .setBehavior('getAccounts', new List<Account>{new Account(Name = 'TestAccount')});
        
        // set mock
        ObjectFactory.mocks.put(
            AccountSelector.class.getName(),
            (AccountSelector) mock.getMock()
        );

        // execute
        AccountService service = new AccountService();
        List<Account> accounts = service.getAccounts();

        // assert
        mock.assertMethodExecutionCount('getAccounts', 1);
        Assert.areEqual(1, accounts.size());
        Assert.areEqual('TestAccount', accounts[0].Name);
    }
}