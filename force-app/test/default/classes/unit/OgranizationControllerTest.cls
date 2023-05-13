/*
 * Class used for testing organization controller 
*/
@isTest
public with sharing class OgranizationControllerTest {
    @isTest
    public static void getOrganizationDefaultCurrency_willUseService() {
        //create mock
        Mocker GetOrganizationDefaultCurrencyServiceMock = new Mocker(GetOrganizationDefaultCurrencyService.class);
        GetOrganizationDefaultCurrencyServiceMock.setBehavior('getCurrency', null);
        GetOrganizationDefaultCurrencyServiceMock.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            GetOrganizationDefaultCurrencyService.class.getName(),
            (GetOrganizationDefaultCurrencyService) GetOrganizationDefaultCurrencyServiceMock.getMock()
        );

        // execute
        OrganizationController.getOrganizationDefaultCurrency();

        // assert
        GetOrganizationDefaultCurrencyServiceMock.assertMethodExecutionCount('getCurrency', 1);
        GetOrganizationDefaultCurrencyServiceMock.assertMethodExecutionCount('getResponse', 1);
    }
}