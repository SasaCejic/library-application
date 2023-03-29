@IsTest
public with sharing class AccountControllerTest {
    @IsTest
    static void getAccounts_WillUseService() {
        // create mock
        Mocker mock = new Mocker(AccountService.class)
            .setBehavior('getAccounts', new List<Account>{new Account(Name = 'TestAccount')});
        
        // set mock
        ObjectFactory.mocks.put(
            AccountService.class.getName(),
            (AccountService) mock.getMock()
        );

        // execute
        List<Account> accounts = AccountController.getAccounts();

        // assert
        mock.assertMethodExecutionCount('getAccounts', 1);
        Assert.areEqual(1, accounts.size());
        Assert.areEqual('TestAccount', accounts[0].Name);
    }
}