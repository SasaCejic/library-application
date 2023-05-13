/*
 * Class used as controller for organization settings
 */
public with sharing class OrganizationController {
    /*
     * Method is used for retrieving organizxation default currency
     */
    @AuraEnabled(cacheable=true)
    public static String getOrganizationDefaultCurrency() {
        GetOrganizationDefaultCurrencyService service = (GetOrganizationDefaultCurrencyService) new ObjectFactory()
            .createObject(GetOrganizationDefaultCurrencyService.class);
        service.getCurrency();
        return service.getResponse();
    }
}