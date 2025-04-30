public with sharing class GetUniqueInternetProviders {

    @InvocableMethod(label='Get Unique Internet Provider Names'  description='Retrieves a list of distinct internet providers from the Internet_Detail__c object for selection in Flow.')
    public static List<List<String>> getProviders(List<String> input) {
        Set<String> providerNames = new Set<String>();
        for (Internet_Detail__c record : [SELECT Provider_Name__c FROM Internet_Detail__c WHERE Provider_Name__c != NULL]) {
            providerNames.add(record.Provider_Name__c);
        }

        List<String> finalNames = new List<String>(providerNames);
        List<List<String>> result = new List<List<String>>();
        result.add(finalNames);
        return result;
    }
}