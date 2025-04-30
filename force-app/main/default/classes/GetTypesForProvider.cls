public class GetTypesForProvider {


    @InvocableMethod(label='Get Types for Selected Provider' description='The Flow used to filter using provider to get the Gas Types')
    public static List<List<String>> getTypes(List<String> input) {
        Set<String> typeSet = new Set<String>();
        String providerName = input[0];

        if (providerName != null) {
            for (Gas_Detail__c record : [
                SELECT Type__c FROM Gas_Detail__c
                WHERE Provider_Name__c = :providerName AND Type__c != NULL
            ]) {
                typeSet.add(record.Type__c);
            }
        }

        List<String> results = new List<String>(typeSet);
        List<List<String>> returnValues = new List<List<String> >();
        returnValues.add(results);

        return returnValues;
    }
}