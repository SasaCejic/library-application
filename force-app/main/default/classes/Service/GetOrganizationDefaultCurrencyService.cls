/*
 * Class used for getting org default currency
 */
public with sharing class GetOrganizationDefaultCurrencyService implements CustomObject{
    private String response;

    //Getter
    public String getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(String defaultCurrency) {
        this.response = defaultCurrency;
    }

    public void getCurrency() {
        ConnectApi.OrganizationSettings  orgSettings = ConnectApi.Organization.getSettings();
        this.setResponse(orgSettings.features.defaultCurrencyIsoCode);
    }
}