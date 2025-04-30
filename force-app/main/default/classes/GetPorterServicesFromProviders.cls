public with sharing class GetPorterServicesFromProviders {
    
    @InvocableMethod(label='Get Types of porters' description='The Flow used to filter using Internet provider to get the Internet Types')
    public static List<List<String>> getTypes(List<String> input) {
        Set<String> typeSet = new Set<String>();
        String providerName = input[0];

        if (providerName != null) {
            for (Porter_Details__c record : [
                SELECT Type__c FROM Porter_Details__c
                WHERE Provider_Name__c = :providerName AND Type__c != NULL
            ]) {
                typeSet.add(record.Type__c);
            }
        }

        List<String> results = new List<String>(typeSet);
        List<List<String>> returnValues = new List<List<String>>();
        returnValues.add(results);

        return returnValues;
    }
}