/*
 * Class used for performing integration tests for OrganizationController
 */
@isTest(SeeAllData=true)
public with sharing class OrganizationControllerIntegrationTest {
    @isTest
    public static void getOrganizationDefaultCurrency() {
        // create data
        String defaultCurrency = ConnectApi.Organization.getSettings().features.defaultCurrencyIsoCode;

        // execute
        String defaultCurrencyForTest = OrganizationController.getOrganizationDefaultCurrency();

        // assert
        Assert.areEqual(defaultCurrency, defaultCurrencyForTest);
    }
}